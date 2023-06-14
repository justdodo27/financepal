from typing import Union, Optional
from datetime import datetime
from itertools import groupby

from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.ext.asyncio import AsyncSession
import fpdf

from backend import crud, schemas, dependencies
from backend.database import get_db


router = APIRouter(dependencies=[])

def return_date_range_type(start_date: datetime, end_date: datetime):
    delta = end_date - start_date
    if delta.days > 31:
        return 'MONTHS'
    elif delta.days <= 31 and delta.days >= 1:
        return 'DAYS'
    return 'HOURS'

@router.get("/statistics/", tags=["statistics"], response_model=schemas.Statistic)
async def get_statistics(start_date: datetime,
                         end_date: datetime,
                         group_id: Union[int, None] = None,
                         current_user: schemas.User = Depends(dependencies.get_current_user),
                         db: AsyncSession = Depends(get_db)):
    range_type = return_date_range_type(start_date, end_date)
    if group_id:
        if not (group := await crud.get_group(db, group_id=group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")
        payments = await crud.get_group_payments(db, group_id, start_date, end_date)
    else:
        payments = await crud.get_user_payments(db, current_user.id, start_date, end_date)
    categories = await crud.categories_grouped(db, start_date, end_date, current_user.id, group_id=group_id)
    categories_sum = sum([category.category_sum for category in categories])
    if range_type == 'HOURS':
        payments_data = [(payment.payment_date.strftime('%H:%M:%S'),
                payment.cost)
             for payment in sorted(payments, key=lambda p: p.payment_date)]
        grouped_data = groupby(payments_data, lambda x: x[0])

        return schemas.Statistic(
            pie_chart_data=[schemas.PieChartRecord(
                category_id=category.id,
                category=category.category,
                percentage=round((category.category_sum/categories_sum)*100, 2),
                value=category.category_sum
            ) for category in categories],
            plot_data=[schemas.LineChartRecord(
                x_data=label,
                y_data=sum([item[1] for item in list(values)])
            ) for label, values in grouped_data],
            payments_list=[schemas.CategoryAggregated(
                category_id=category.id,
                name=category.category,
                value=category.category_sum,
                count=category.category_count
            ) for category in categories]
        )
    elif range_type == 'DAYS':
        payments_data = [(payment.payment_date.strftime('%d/%m'),
                payment.cost)
             for payment in sorted(payments, key=lambda p: p.payment_date)]
        grouped_data = groupby(payments_data, lambda x: x[0])

        return schemas.Statistic(
            pie_chart_data=[schemas.PieChartRecord(
                category_id=category.id,
                category=category.category,
                percentage=round((category.category_sum/categories_sum)*100, 2),
                value=category.category_sum
            ) for category in categories],
            plot_data=[schemas.LineChartRecord(
                x_data=label,
                y_data=sum([item[1] for item in list(values)])
            ) for label, values in grouped_data],
            payments_list=[schemas.CategoryAggregated(
                category_id=category.id,
                name=category.category,
                value=category.category_sum,
                count=category.category_count
            ) for category in categories]
        )
    elif range_type == 'MONTHS':
        payments_data = [(payment.payment_date.strftime('%m/%y'),
                payment.cost)
             for payment in sorted(payments, key=lambda p: p.payment_date)]
        grouped_data = groupby(payments_data, lambda x: x[0])

        return schemas.Statistic(
            pie_chart_data=[schemas.PieChartRecord(
                category_id=category.id,
                category=category.category,
                percentage=round((category.category_sum/categories_sum)*100, 2),
                value=category.category_sum
            ) for category in categories],
            plot_data=[schemas.LineChartRecord(
                x_data=label,
                y_data=sum([item[1] for item in list(values)])
            ) for label, values in grouped_data],
            payments_list=[schemas.CategoryAggregated(
                category_id=category.id,
                name=category.category,
                value=category.category_sum,
                count=category.category_count
            ) for category in categories]
        )
    

@router.get("/report/", tags=["statistics"], response_model=str)
async def get_payments_report(request: Request,
                              start_date: datetime,
                                end_date: datetime,
                                group_id: Union[int, None] = None,
                                current_user: schemas.User = Depends(dependencies.get_current_user),
                                db: AsyncSession = Depends(get_db)):
    if group_id:
        if not (group := await crud.get_group(db, group_id=group_id)):
            raise HTTPException(status_code=404, detail="Group not found")
        if not group.is_member(current_user):
            raise HTTPException(status_code=403, detail="You don't belong to this group")
        payments = await crud.get_group_payments(db, group_id, start_date, end_date)
    else:
        payments = await crud.get_user_payments(db, current_user.id, start_date, end_date)

    pdf = fpdf.FPDF()
    
    # Add a page
    pdf.add_page()
    
    # set style and size of font
    # that you want in the pdf
    pdf.set_font("Arial", size = 15)
    
    # create a cell
    pdf.cell(200, 10, txt = f"{current_user.username} payments report",
            ln = 1, align = 'C')
    
    # add another cell
    pdf.cell(200, 10, txt = f"{start_date} - {end_date}",
            ln = 2, align = 'C')
    pdf.set_font("Courier", size = 11)
    payments_sum = 0
    for idx, payment in enumerate(payments):
        text_content = f"{payment.name: <31} | {payment.category.category if payment.category_id else 'None' : <8} | {round(payment.cost, 2): <7} | {payment.payment_date.strftime('%Y-%m-%d %H:%M:%S'): <14} | {payment.type.value : <6}".encode('latin-1', 'replace').decode('latin-1')
        pdf.cell(195, 10, txt=text_content, border=1, align='L', ln=3+idx)
        payments_sum += payment.cost
    text_content = f"{'Payment name': <31} | {'Category' : <8} | {round(payments_sum,2): <7} | {'Date': <19} | {'Type': <6}".encode('latin-1', 'replace').decode('latin-1')
    pdf.cell(195, 10, txt=text_content, border=1, align='L', ln=3+len(payments))
    # save the pdf with name .pdf
    filename = f"{current_user.username}-{datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S')}"
    pdf.output(f"./backend/static/{filename}.pdf") 

    return f'{request.base_url}static/{filename}.pdf'
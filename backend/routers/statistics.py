from typing import Union, Optional
from datetime import datetime
from itertools import groupby

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from backend import crud, schemas, dependencies
from backend.database import get_db


router = APIRouter(dependencies=[])

def return_date_range_type(start_date: datetime, end_date: datetime):
    if start_date.year != end_date.year:
        return 'MONTHS'
    if start_date.month != end_date.month:
        return 'MONTHS'
    if start_date.day != end_date.day:
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
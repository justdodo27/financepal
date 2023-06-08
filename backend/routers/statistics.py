from typing import Union, Optional
from datetime import datetime
import uuid
import os
from itertools import groupby

from fastapi import APIRouter, Depends, HTTPException, Path, UploadFile, Request
from sqlalchemy.ext.asyncio import AsyncSession
import aiofiles

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
async def get_statistics(start_date: datetime = None,
                         end_date: datetime = None,
                         current_user: schemas.User = Depends(dependencies.get_current_user),
                         db: AsyncSession = Depends(get_db)):
    range_type = return_date_range_type(start_date, end_date)
    payments = await crud.get_user_payments(db, current_user.id, start_date, end_date)
    categories = await crud.categories_grouped(db, start_date, end_date, current_user.id, group_id=None)
    categories_sum = sum([category.category_sum for category in categories])
    if range_type == 'HOURS':
        payments_data = [(f"{payment.payment_date.hour}:{payment.payment_date.minute}",
                payment.cost)
             for payment in sorted(payments, key=lambda p: p.payment_date)]
        grouped_data = groupby(payments_data, lambda x: x[0])

        return schemas.Statistic(
            pie_chart_data=[schemas.PieChartRecord(
                category_id=category.id,
                category=category.category,
                percentage=category.category_sum/categories_sum,
                value=category.category_sum
            ) for category in categories],
            plot_data=[schemas.LineChartRecord(
                x_data=label,
                y_data=sum([item[1] for item in list(values)])
            ) for label, values in grouped_data],
            payments_list=payments
        )
    elif range_type == 'DAYS':
        payments_data = [(f"{payment.payment_date.day}/{payment.payment_date.month}",
                payment.cost)
             for payment in sorted(payments, key=lambda p: p.payment_date)]
        grouped_data = groupby(payments_data, lambda x: x[0])

        return schemas.Statistic(
            pie_chart_data=[schemas.PieChartRecord(
                category_id=category.id,
                category=category.category,
                percentage=category.category_sum/categories_sum,
                value=category.category_sum
            ) for category in categories],
            plot_data=[schemas.LineChartRecord(
                x_data=label,
                y_data=sum([item[1] for item in list(values)])
            ) for label, values in grouped_data],
            payments_list=[schemas.CategoryAggregated(
                category_id=category.id,
                category=category.category,
                payments_sum=category.category_sum,
                payments_count=category.category_count
            ) for category in categories]
        )
    elif range_type == 'MONTHS':
        payments_data = [(f"{payment.payment_date.month}/{payment.payment_date.year}",
                payment.cost)
             for payment in sorted(payments, key=lambda p: p.payment_date)]
        grouped_data = groupby(payments_data, lambda x: x[0])

        return schemas.Statistic(
            pie_chart_data=[schemas.PieChartRecord(
                category_id=category.id,
                category=category.category,
                percentage=category.category_sum/categories_sum,
                value=category.category_sum
            ) for category in categories],
            plot_data=[schemas.LineChartRecord(
                x_data=label,
                y_data=sum([item[1] for item in list(values)])
            ) for label, values in grouped_data],
            payments_list=[schemas.CategoryAggregated(
                category_id=category.id,
                category=category.category,
                payments_sum=category.category_sum,
                payments_count=category.category_count
            ) for category in categories]
        )
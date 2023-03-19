from fastapi import APIRouter

router = APIRouter()


@router.get("/test/", tags=["users"])
async def test():
    return {"status": "OK"}
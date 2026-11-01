import os
import socket
from datetime import datetime, timezone

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Cloud Practice API", version="0.1.0")

# In-memory store; resets on every restart (fine for deploy testing)
items: dict[int, dict] = {}
next_id = 1


class ItemIn(BaseModel):
    name: str
    description: str | None = None


@app.get("/")
def root():
    return {"message": "Hello from Cloud Practice API"}


@app.get("/health")
def health():
    # Point your ALB / ECS / App Runner health check here
    return {"status": "ok"}


@app.get("/info")
def info():
    # Handy for confirming which instance/container served the request
    return {
        "hostname": socket.gethostname(),
        "environment": os.getenv("APP_ENV", "local"),
        "time": datetime.now(timezone.utc).isoformat(),
    }


@app.get("/items")
def list_items():
    return list(items.values())


@app.post("/items", status_code=201)
def create_item(item: ItemIn):
    global next_id
    record = {"id": next_id, **item.model_dump()}
    items[next_id] = record
    next_id += 1
    return record


@app.get("/items/{item_id}")
def get_item(item_id: int):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    return items[item_id]


@app.delete("/items/{item_id}", status_code=204)
def delete_item(item_id: int):
    if items.pop(item_id, None) is None:
        raise HTTPException(status_code=404, detail="Item not found")

import random
from locust import HttpUser, task, between

class QuickstartUser(HttpUser):
    wait_time = between(5, 9)

    @task
    def index_page(self):
        self.client.get("/custom-user-dashboard-backend/auth/currentUser")
        self.client.get("/custom-user-dashboard/user/login")

    @task(3)
    def view_item(self):
        item_id = random.randint(1, 10000)
        self.client.post(f"/item?id={item_id}", name="/item")

    def on_start(self):
        self.client.get("/")
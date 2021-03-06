from locust import HttpUser, TaskSet, task, between

class ForumThread(TaskSet):
    pass

class ForumPage(TaskSet):
    # wait_time can be overridden for individual TaskSets
    wait_time = between(10, 300)
    
    # TaskSets can be nested multiple levels
    tasks = {
        ForumThread:3
    }
    
    @task(3)
    def forum_index(self):
        pass
    
    @task(1)
    def stop(self):
        self.interrupt()

class AboutPage(TaskSet):
    pass

class WebsiteUser(HttpUser):
    wait_time = between(5, 15)
    
    # We can specify sub TaskSets using the tasks dict
    tasks = {
        ForumPage: 20,
        AboutPage: 10,
    }
    
    # We can use the @task decorator as well as the  
    # tasks dict in the same Locust/TaskSet
    @task(10)
    def index(self):
        pass
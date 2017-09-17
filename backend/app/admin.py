from django.contrib import admin

from app.models import Joke, Lol, User

admin.site.register(Joke)
admin.site.register(User)
admin.site.register(Lol)
# Register your models here.

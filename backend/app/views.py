from django.shortcuts import render
from django.http import HttpResponse
from app.models import User, Joke, Lol
from app.helper import find_match
import random, json


def get_joke(request, user_id):
    usr = User.objects.get(pk=user_id)
    jokes = set(Joke.objects.all().values_list('pk', flat=True))
    lols = set(Lol.objects.filter(user=usr).values_list('pk', flat=True))

    remain = list(jokes - lols)

    j = Joke.objects.get(pk=random.choice(remain))

    ret = {'pk':j.pk,
           'joke': j.content}

    return HttpResponse(json.dumps(ret))


def respond_joke(request,user_id,joke_id,response_id):
    usr = User.objects.get(pk=user_id)
    joke = Joke.objects.get(pk=joke_id)

    response = Lol()
    response.joke = joke
    response.user = usr
    response.rating = response_id

    response.save()

    #### CHECK IF THERE ARE MATCHES

    match = find_match(usr)

    return HttpResponse(json.dumps({'status':True}))
    # if matches:
    #     json_resp =
    #     return HttpResponse({'match':True,'data':matches})


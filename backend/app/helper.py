import numpy as np
import scipy as sc
import pandas as pd
import random

from app.models import Joke, Lol, User
from model_mommy import mommy

def make_users(gender):
    for i in range(0,20):
        usr = mommy.make(User)
        usr.gender = gender
        usr.interested_in = 2 if gender == 1 else 1
        usr.save()

def make_jokes():
    usr = User.objects.all()[0]
    for i in range(0,100):
        joke = mommy.make(Joke)
        old = joke.added_by
        joke.added_by = usr
        joke.save()
        old.delete()

def simulate_likes():
    users = User.objects.all()[2:]
    jokes = Joke.objects.all()
    for u in users:
        for j in jokes:
            if random.choice([0,0,0,0,1,0,1,0,0,1]) == 1:
                lolwut = Lol()
                lolwut.user = u
                lolwut.joke = j
                lolwut.rating = random.choice([-1,1])
                lolwut.save()


# keep it clean and tidy
def float_format(vector, decimal):
    return np.round((vector).astype(np.float), decimals=decimal)


def find_match(user_id):
    jokes = Joke.objects.all()
    usr = User.objects.get(pk=user_id)
    users = User.objects.filter(gender=usr.interested_in)
    relations = Lol.objects.filter(user__in=list(users))
    u_relation = Lol.objects.filter(user=usr)

    user_vecs = [[0.0 for i in range(len(jokes)+1)] for j in range(len(users)+1)]
    my_vec = [0.0 for i in range(len(jokes)+1)]

    user_vec_pos = {}
    joke_vec_pos = {}

    for i,i_user in enumerate(users):
        user_vec_pos[i_user] = i
    for i,j in enumerate(jokes):
        joke_vec_pos[j] = i

    for r in relations:
        print user_vec_pos[r.user]
        print joke_vec_pos[r.joke]
        user_vecs[user_vec_pos[r.user]][joke_vec_pos[r.joke]] = r.rating

    for r in u_relation:
        my_vec[joke_vec_pos[r.joke]] = r.rating

    joke_graph = [[0 for i in range(len(jokes))] for j in range(len(jokes))]

    for i in range(len(jokes)-1):
        for j in range(i,len(jokes)):
            for l in user_vecs:
                if l[i] == l[j]:
                    joke_graph[i][j] += 1
                    joke_graph[j][i] += 1

    pre_eig = [[0.0 for i in range(len(jokes))] for j in range(len(jokes))]

    for i in range(len(jokes)):
        for j in range(i,len(jokes)):
            if joke_graph[i][j] != 0:
                pre_eig[i][j] = 1.0/joke_graph[i][j]

    M = np.matrix(pre_eig)

    E = np.zeros((len(jokes), len(jokes)))
    E[:] = 0.333

    beta = 0.7

    A = beta * M + ((1 - beta) * E)

    r = np.matrix([0.333 for i in range(len(jokes))])
    r = np.transpose(r)

    previous_r = r
    for it in range(1, 100):
        r = A * r
        # print float_format(r, 3)
        if (previous_r == r).all():
            break
        previous_r = r

    # print "Final:\n", float_format(r, 3)

    prods = [0 for i in range(len(users))]

    prod_max = 0

    for i,u in enumerate(users):
        for j in range(len(jokes)):
            prods[i] += user_vecs[i][j]*my_vec[j]*r[j]
        if prods[i]>prod_max:
            prod_max = i

    print my_vec
    print "__--------___"
    print

    return users[prod_max]














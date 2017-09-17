from django.db import models

class User(models.Model):
    g_choices = (
        (1,'Male'),
        (2,'Female'),
        (3,'Others')
    )
    gender = models.IntegerField(choices=g_choices)
    interested_in = models.IntegerField(choices=g_choices)

    def __unicode__(self):
        return str(self.pk)

    class Meta:
        app_label = 'app'


class Joke(models.Model):

    joke_cat = (
        (1,'Text'),
        (2, 'Meme')
    )

    category = models.IntegerField(choices=joke_cat)
    content = models.CharField(max_length=1000)
    added_by = models.ForeignKey(User)
    like = models.BigIntegerField(default=0)
    dislike = models.BigIntegerField(default=0)
    joke_vec = models.CharField(max_length=5000)

    def __unicode__(self):
        return str(self.pk)

    class Meta:
        app_label = 'app'


class Lol(models.Model):
    lol_choices = (
        (1,'LOL'),
        (-1,"Nah")
    )
    joke = models.ForeignKey(Joke)
    user = models.ForeignKey(User)
    rating = models.IntegerField(choices=lol_choices)

    def __unicode__(self):
        return str(self.pk)

    class Meta:
        app_label = 'app'
from django.urls import path
from django.conf.urls import url
from recos.views import RecoView

urlpatterns = [
    url(r'^$', RecoView.as_view(), name='index'),

    # path('', views.index, name='index'),
]

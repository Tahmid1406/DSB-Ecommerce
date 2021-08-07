from django.contrib import admin
from django.urls import path
from .views import home, order, register, account


urlpatterns = [
    path('', home, name='home'),
    path('order', order, name='order'),
    path('register', register, name='register'),
    path('account', account, name='account'),
]

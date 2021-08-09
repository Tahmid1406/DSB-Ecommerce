from django.contrib import admin
from django.contrib.auth import views as auth_views
from django.urls import path
from .views import home, order, register, account, product_detail


urlpatterns = [
    path('', home, name='home'),
    path('product/<str:slug>/<int:id>', product_detail, name='product_detail'),
    path('order', order, name='order'),
    path('register', register, name='register'),
    path('account', account, name='account'),
    path('login', auth_views.LoginView.as_view(
        template_name='application/login.html'), name='login'),
    path('logout', auth_views.LogoutView.as_view(
        template_name='application/logout.html'), name='logout'),
]

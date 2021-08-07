from django.shortcuts import render
from .models import Category, Product


def home(request):
    data = Product.objects.all()

    return render(request, 'application/home.html', {'data': data})


def order(request):
    return render(request, 'application/order.html')


def register(request):
    return render(request, 'application/register.html')


def customerRegistration(request):
    return render(request, 'application/customerRegistration.html')


def sellerRegistration(request):
    return render(request, 'application/sellerRegistration.html')


def account(request):
    return render(request, 'application/account.html')

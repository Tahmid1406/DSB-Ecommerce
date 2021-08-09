from django.shortcuts import render, redirect
from .models import Category, Product
from django.contrib.auth.forms import UserCreationForm
from django.contrib import messages
from .forms import UserRegisterForm


def home(request):
    data = Product.objects.all()

    return render(request, 'application/home.html', {'data': data})


def product_detail(request, slug, id):
    product = Product.objects.get(id=id)
    return render(request, 'application/product_detail.html', {'data': product})


def order(request):
    return render(request, 'application/order.html')


def register(request):
    if request.method == 'POST':
        form = UserRegisterForm(request.POST)
        if form.is_valid():
            form.save()
            username = form.cleaned_data.get('username')
            messages.success(
                request, f'Account created for {username}. Please login to continue')
            return redirect('login')

    else:
        form = UserRegisterForm()

    return render(request, 'application/register.html', {'form': form})


def customerRegistration(request):
    return render(request, 'application/customerRegistration.html')


def sellerRegistration(request):
    return render(request, 'application/sellerRegistration.html')


def account(request):
    return render(request, 'application/account.html')

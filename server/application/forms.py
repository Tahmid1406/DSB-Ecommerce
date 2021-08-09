from django import forms
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm


class UserRegisterForm(UserCreationForm):
    email = forms.EmailField(
        label="",
        widget=forms.EmailInput(
            attrs={'class': 'form-control', 'type': 'email', 'placeholder': 'enter mail address'}),
    )

    password1 = forms.CharField(
        label="",
        widget=forms.PasswordInput(
            attrs={'class': 'form-control', 'type': 'password', 'placeholder': 'enter password'}),
    )
    password2 = forms.CharField(
        label="",
        widget=forms.PasswordInput(
            attrs={'class': 'form-control', 'type': 'password',  'placeholder': 'confirm password'}),
    )

    class Meta:
        model = User
        fields = ['username', 'email', 'password1', 'password2']

        labels = {
            'username': "",
            'email': "",
        }

        widgets = {
            'username': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Enter Your Name',
            }),

            'email': forms.EmailInput(attrs={
                'class': 'form-control',
                'placeholder': 'Enter Email'
            }),


            'password1': forms.PasswordInput(attrs={
                'class': 'form-control',
            })
        }

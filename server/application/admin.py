from django.contrib import admin
from .models import Category, Brand, Product, UserAccount
# Register your models here.

admin.site.register(Category)
admin.site.register(Brand)
admin.site.register(UserAccount)


class ProductAdmin(admin.ModelAdmin):
    list_display = ('id', 'brand', 'category', 'title', 'price',)


admin.site.register(Product, ProductAdmin)

from django.db import models
from django.contrib.auth.models import User


class Category(models.Model):
    title = models.CharField(max_length=100)
    image = models.ImageField(upload_to='category_img/')

    def __str__(self):
        return self.title


class Brand(models.Model):
    title = models.CharField(max_length=100)
    image = models.ImageField(upload_to='brand_img/')

    def __str__(self):
        return self.title


class Product(models.Model):
    brand = models.ForeignKey(Brand, on_delete=models.CASCADE)
    category = models.ForeignKey(Category, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    slug = models.CharField(max_length=400)
    details = models.TextField()
    price = models.PositiveIntegerField()
    image = models.ImageField(upload_to="product_image/")

    def __str__(self):
        return self.title


class UserAccount(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    step = models.IntegerField()
    type = models.IntegerField()
    isFlaggedFraud = models.IntegerField()

    amount = models.DecimalField(max_digits=50, decimal_places=5, default="")
    oldbalanceOrg = models.DecimalField(
        max_digits=50, decimal_places=5, default="")
    newbalanceOrig = models.DecimalField(
        max_digits=50, decimal_places=5, default="")
    oldbalanceDest = models.DecimalField(
        max_digits=50, decimal_places=5, default="")
    newbalanceDest = models.DecimalField(
        max_digits=50, decimal_places=5, default="")
    errorBalanceOrig = models.DecimalField(
        max_digits=50, decimal_places=5, default="")
    errorBalanceDest = models.DecimalField(
        max_digits=50, decimal_places=5, default="")

    def __str__(self):
        return self.user

# class User(AbstractUser):
#     is_customer = models.BooleanField(default=False)
#     is_seller = models.BooleanField(default=False)
#     name = models.CharField(max_length=100)


# class Customer(models.Model):
#     user = models.OneToOneField(
#         User, on_delete=models.CASCADE, primary_key=True)
#     phone_number = models.CharField(max_length=15)
#     location = models.CharField(max_length=50)


# class Seller(models.Model):
#     user = models.OneToOneField(
#         User, on_delete=models.CASCADE, primary_key=True)
#     phone_number = models.CharField(max_length=15)
#     company = models.CharField(max_length=50)

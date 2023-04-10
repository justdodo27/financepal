# financepal
App for managing finances

## Debug token
* endrju - `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIn0.eSArqeSJ4EtfNxr1IPpIyk2YFs9IFz-cWynIKyWyL7k`
* dodo - `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyIn0.BHuk4FoBbQkceI_rbnUrv2c45FOtNYxY4vjMShzM9bM`
* syra - `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzIn0.l5NfayRHN-8D7DYkBorr-dYZF9QrjkPS53xk0kRCSRY`

## How to start the app
1. Install Docker
2. On main project directory run `docker compose up --build`
3. API is working under [http://localhost:8080](http://localhost:8080)
4. To access the docs open [http://localhost:8080/docs/](http://localhost:8080/docs/)

## Popular errors
- Random couritne error 

You either forgot about *await* or *async*, or some random shit happended i.e SQLalchemy loads relationship data by 'lazy method' which loads data on first call
```
x = model
x.myrelation # <-- this will load the myrelation so if you don't add await you will have error XD
```

To prevent this behavior add lazy='selectin' or lazy='joined' to relationship
```
category = relationship("Category", back_populates="payments", lazy='selectin')
```

- I added something at datetime X and filtered data by datetime Y and my record isn't there!

Make sure that you use utc format i.e. your 19 o clock on utc will be 17 o clock etc.
I can change it if this will be problematic at some point XD
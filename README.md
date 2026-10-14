# Práctica 4. Modelo relacional. Viveros.

## Modelo ER

<img width="1463" height="1262" alt="entidad-relacion" src="https://github.com/user-attachments/assets/19f33e67-e91c-4a54-aaa6-e214907953f4" />

## Modelo relacional

<img width="1624" height="733" alt="modelo-relacional" src="https://github.com/user-attachments/assets/76d158bb-24fb-4e40-b9dd-70a50fbcd2f0" />

## Tablas 

### vivero

<img width="565" height="177" alt="image" src="https://github.com/user-attachments/assets/be01f1a3-bc4f-4034-938d-c9c7c40e0d27" />

### zona

<img width="669" height="171" alt="image" src="https://github.com/user-attachments/assets/2c25619f-cb3f-495c-a095-3306638da476" />

### producto

<img width="567" height="189" alt="image" src="https://github.com/user-attachments/assets/d38be41d-59c5-425e-9272-f0ddd3b3a1f1" />

### puesto

<img width="444" height="180" alt="image" src="https://github.com/user-attachments/assets/726c60f9-0cc1-46e4-80a0-e64bed876d1d" />

### empleado

<img width="562" height="193" alt="image" src="https://github.com/user-attachments/assets/4a37f7f8-33a7-44f8-8f6a-68508d5ed805" />

### cliente

<img width="670" height="183" alt="image" src="https://github.com/user-attachments/assets/afbc31a5-ab0f-4e07-be4f-057eb9ad1fd8" />

### bonificación

<img width="588" height="192" alt="image" src="https://github.com/user-attachments/assets/a4c70ae8-f801-48cd-920b-44fe5cdd7dc4" />

### pedido

<img width="715" height="194" alt="image" src="https://github.com/user-attachments/assets/adda578d-3d52-48d0-962a-ab559b664cbc" />

## DELETE

Con este ejemplo representativo de que la eliminación por DELETE es en cascada.

<img width="549" height="138" alt="image" src="https://github.com/user-attachments/assets/c69f85b2-abd9-4e92-a356-81d1f5c0c334" />

<img width="829" height="142" alt="image" src="https://github.com/user-attachments/assets/521d9e50-17ac-4034-903a-ea9fd9dd3b9f" />

```sql
DELETE FROM zona
WHERE id_vivero = 1 AND id_zona = 2;
```

<img width="694" height="155" alt="image" src="https://github.com/user-attachments/assets/ca9f6cee-7625-4ef4-86bc-30f9cf3b55f8" />

<img width="822" height="123" alt="image" src="https://github.com/user-attachments/assets/7d067ebc-934d-43b4-9fba-ed302dfb2aeb" />

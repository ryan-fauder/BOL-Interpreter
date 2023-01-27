# Test 1
vars a, b, c, d
a = 10
b = 20
c = new Pessoa
d = new Account

c.name = 5
b = c.name
io.print(b)
c.setName(a)
a = c.name
io.print(a)
a = 500
Pessoa.setName._delete(1):
c.setName(a)
a = c.name
io.print(a)


io.dump(c)
io.dump(d)


# Test 2
  vars account, ret, value, tax  
  account = new Account

  value = 200
  account.value = value
  value = 100
  tax = 5
  io.print(value)
' account.setId(value)
  io.print(ret)


# Test 3 (ERRO NO PROTOTYPE)
  vars account, ret, value, tax, person, a, b, c
  person = new Pessoa
  account = new Account


  person._prototype = account
  person.id = 10
  person.printId()
  
  value = 200
  account.value = value
  value = 100
  tax = 5

  ret = account.transfer(value, tax)
  
  person.setId(tax)

# Test 4 ( NÃO PASSOU - ERRO NO PROTOTYPE)
  vars account, person, temp
  person = new Pessoa
  account = new Account


  person._prototype = account
  person.id = 10
  temp = person.id
  io.print(temp)
  temp = account.id
  io.print(temp)

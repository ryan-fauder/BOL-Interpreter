## Test 1

class Pessoa
    vars name, age

    method setName(name)
    begin
        self.name = name
        io.print(name)
    end-method

    method getName()
    vars name
    begin
      name = self.name
      return name
    end-method

end-class

class Account
    vars id, owner, value
    
    method setId(id)
    vars a
    begin
      self.id = id
      a = self.id
      io.print(a)

    end-method

    method transfer(valueA, tax)
    vars aux, temp
    begin
      aux = valueA * tax
      aux = valueA + aux
      temp = self.value
      self.value = temp + aux
      temp = self.value
      io.print(temp)
      return temp
    end-method

    method printId()
    vars id
    begin
        id = self.id
        io.print(id)
    end-method

end-class

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


## Test 2
  vars account, ret, value, tax  
  account = new Account

  value = 200
  account.value = value
  value = 100
  tax = 5
  io.print(value)
' account.setId(value)
  io.print(ret)


## Test 3 (ERRO NO PROTOTYPE)
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

## Test 4 ( NÃO PASSOU - ERRO NO PROTOTYPE)
  vars account, person, temp
  person = new Pessoa
  account = new Account


  person._prototype = account
  person.id = 10
  temp = person.id
  io.print(temp)
  temp = account.id
  io.print(temp)

## Test 5 (URI)

class For

	method for(start, stop, step, A)
	vars i
	begin
		i = start
		if i ge stop then
			return A
		end-if
		A = A + i
		i = i + step 
		i = self.for(i, stop, step, A)
		return A
	end-method
end-class

begin
	vars uri, A, start, N, step, ret
	uri = new For

	start = 0
	N = 2
	step = 1
	A = 3

	ret = uri.for(start, N, step, A)

	A = ret + A
	
	io.print(A)

end


# ==== TESTES FINAIS ====

## Test 1 (Meta ação de replace em uma função aninhada)

## Test 2 (Recursão em duas funções aninhadas)

## Test 3 (Loop FOR)

## Test 4 (Passagem de parâmetro)

> (Mudança de valores passados como parâmetro - uma classe e um número)

```

```
## Test 5 (If e if-else aninhados em métodos e na main)

## Test 6 (Self acessando método/atributo em um prototype)

## Test 7 (Criação de objeto dentro de um método e retorno desse objeto)

## Test 8 (Uso de valores de parâmetros fora do método)

## Test 9 (Após realizar meta-ações, ver se as variáveis prototype foram afetadas)






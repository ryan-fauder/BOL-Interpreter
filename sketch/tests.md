# Testes

## Test 1

```
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

begin
  vars account, ret, value, tax, person, a, b, c
  person = new Pessoa
  account = new Account

  person._prototype = account
  person.id = 10

  person.setAccount(account)

  person.printId()
  account.printId()

  value = 200
  account.value = value
  value = 100
  tax = 5

  ret = account.transfer(value, tax)
  io.print(ret)
  person.setId(tax)
  account.printId()
end
```

## Test 2

```
  vars account, ret, value, tax  
  account = new Account

  value = 200
  account.value = value
  value = 100
  tax = 5
  io.print(value)
' account.setId(value)
  io.print(ret)
```

## Test 3 (ERRO NO PROTOTYPE)

```
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
```
## Test 4 ( NÃO PASSOU - ERRO NO PROTOTYPE)

```
  vars account, person, temp
  person = new Pessoa
  account = new Account

  person._prototype = account
  person.id = 10
  temp = person.id
  io.print(temp)
  temp = account.id
  io.print(temp)
```

## Test 5 (URI)

```
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

```

# ==== TESTES FINAIS ====

## Test 1 (Meta ação de replace em uma função aninhada)
```

```
## Test 2 (Recursão em duas funções aninhadas)
```
```
## Test 3 (Loop FOR)
```
```
## Test 4 (Passagem de parâmetro)

> (Mudança de valores passados como parâmetro - uma classe e um número)

```
  class Obj
   vars valueA, valueB
  end-class
  
  class Class
    method classparam(obj, v)
    begin
        obj.valueA = 10
        obj.valueB = v
    end-method
    
    method numberparam(var)
    begin
        var = 15
    end-method
    method varparam(var)
    vars a
    begin
        a = 10
        var = a
    end-method
  end-class

  begin
    vars obj, num, aux
    obj = new Obj
    obj.valueA = 20
    obj.valueB = 30
    aux = obj.valueA
    io.print
  end
```

## Test 5 (If e if-else aninhados em métodos e na main)
> Código:
```
class Foo
    vars x, y

    method bar(k)
    vars a, b
    begin
        a = 10
        b = 15
        if a ge b then
            k = k + a
            return k
        else
            k = k + b
            return k
        end-if
    end-method

    method baz(k)
    vars c, d
    begin
        c = 10
        d = 15
        if c ne d then
            k = k + c
            return k
        else
            k = k + d
            return k
        end-if
    end-method

end-class

begin
    vars f, x, y, z, k
    f = new Foo
    x = 40
    y = 50

    k = 100
    if x eq y then
        z = f.bar(k)
    else
        z = f.baz(k)
    end-if

    io.print(z)
end

```
> Resultado:
```
    110
```


## Test 6 (Self acessando método/atributo em um prototype)
> Código:
```
class Foo
    vars x, y

    method baz()
    vars a
    begin
        a = self.x
        io.print(a)
    end-method
end-class

```
> Resultado:
```

```



## <Test 7 (Criação de objeto dentro de um método e retorno desse objeto)>
> Código:
```
class Temp
    vars x, y

    method baz()
    vars a
    begin
        a = self.x
        io.print(a)
    end-method
end-class

class Foo
    vars i, j

    method bar()
    vars objOne, objTwo, a, b
    begin
        objOne = new Foo
        objTwo = new Temp
        self.i = 200
        objOne.i = self.i
        a = objOne.i
        objTwo.x = a
        objTwo.y = 150
        return objTwo
    end-method
end-class

begin
    vars a, b, c

    a = new Foo
    b = a.bar()
    c = b.x
    io.print(c)
    c = b.y
    io.print(c)
end

```
> Resultado:
```
  20
  15
```


## Test 8 (Uso de valores de parâmetros fora do método)
> Código:
```
class Foo
    vars x, y

    method baz()
    vars a
    begin
        a = self.x
        io.print(a)
    end-method
end-class

```
> Resultado:
```

```


## Test 9 (Após realizar meta-ações, ver se as variáveis prototype foram afetadas)
> Código:
```
class Foo
    vars x, y

    method baz()
    vars a
    begin
        a = self.x
        io.print(a)
    end-method
end-class

```
> Resultado:
```

```


## Test 10 (Recursão)
> Código:
```
class Foo
    vars x, y

    method baz()
    vars a
    begin
        a = self.x
        io.print(a)
    end-method
end-class

```
> Resultado:
```

```



## Test 11 (Acessar uma função de um prototype de prototype de um objeto)
> Código:
```
class Foo
    vars x, y

    method baz()
    vars a
    begin
        a = self.x
        io.print(a)
    end-method
end-class

```
> Resultado:
```

```



## Test 12 (Alteração de um objeto enviado como parâmetro)
> Código:
```
class Foo
    vars x, y

    method baz()
    vars a
    begin
        a = self.x
        io.print(a)
    end-method
end-class

```
> Resultado:
```

```



## Test 13 (Testes da metação de insert, delete, replace e imprime com o io.dump)
> Código:
```
class Foo
    vars x, y

    method baz()
    vars a
    begin
        a = self.x
        io.print(a)
    end-method
end-class

```
> Resultado:
```

```


## Test 14 (Retorno dentro de if, depois dentro de um else e depois um retorno do valor de uma função dentro de outra.)
> Código:
```
class Foo
    vars x, y

    method baz()
    vars a
    begin
        a = self.x
        io.print(a)
    end-method
end-class

```
> Resultado:
```

```


## Test 15 (Atribuição com soma, com retorno de método, com número, com atributo para atributo)
> Código:
```
class Foo
    vars x, y

    method baz()
    vars a
    begin
        a = self.x
        io.print(a)
    end-method
end-class

```
> Resultado:
```

```


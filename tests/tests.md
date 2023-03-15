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
class Obj
  vars value

  method loop(obj)
  vars three, aux
  begin
    For.for._replace(1): return stop
    io.dump(obj)
  end-method
end-class

class For

 method for(start, stop, step, obj)
 vars i
 begin
  i = start
  if i ge stop then
    obj.loop(self)
    return i
  end-if

  i = i + step
  i = self.for(i, stop, step, obj)

  return i
 end-method
end-class

begin
 vars for, obj, start, stop, step, aux, result
 for = new For
 obj = new Obj
 obj.value = 10
 start = 0
 stop = 2
 step = 1

 result = for.for(start, stop, step, obj)
 io.print(result)
 aux = obj.value
 io.print(aux)
end
```
## Test 2 (Recursão em duas funções aninhadas)
```
class Obj
  vars value

  method loop(start, stop, step)
  vars i
  begin
    i = start
    if i ge stop then
    return i
    end-if

    i = i + step
    i = self.loop(i, stop, step)

    return i
  end-method
end-class

class For

 method for(start, stop, step, obj)
 vars i, j, k, result, ten
 begin
  i = start
  if i ge stop then
   return i
  end-if
  ten = 10
  j = stop + ten
  k = 2

  result = obj.loop(start, j, k)
  
  i = i + step
  i = self.for(i, stop, step, obj)

  return result
 end-method
end-class

begin
 vars for, obj, start, stop, step, aux, result
 for = new For
 obj = new Obj
 obj.value = 10
 start = 0
 stop = 2
 step = 1

 result = for.for(start, stop, step, obj)
 io.print(result)
  
end
```
## Test 3 (Loop FOR)
```
class Obj
  vars value

  method loop()
  vars three, aux
  begin
    three = 3
    aux = self.value
    self.value = aux * three
  end-method
end-class

class For

 method for(start, stop, step, obj)
 vars i
 begin
  i = start
  if i ge stop then
   return i
  end-if


  obj.loop()
  
  i = i + step
  i = self.for(i, stop, step, obj)

  return i
 end-method
end-class

begin
 vars for, obj, start, stop, step, aux, result
 for = new For
 obj = new Obj
 obj.value = 10
 start = 0
 stop = 2
 step = 1

 result = for.for(start, stop, step, obj)
 io.print(result)
 aux = obj.value
 io.print(aux)
end
```

> Resultado
```
    2
    90
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
    io.print(aux)
  end
```
> Resultado:
```
    20
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


class Bar
    vars i, j

    method qux()
    vars b
    begin
        b = self.i
        io.print(b)
    end-method
end-class

begin
    vars k, v
    k = new Foo
    v = new Bar

    k._prototype = v

    k.i = 250
    k.qux()


end

```
> Resultado:
```
    250
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
  200
  150
```


## <Test 8 (Uso de valores de parâmetros fora do método)
> Código:
```
class Foo
    vars x, y

    method baz(a, b)
    vars i
    begin
        self.x = 10
        a = self.x
        io.print(a)
    end-method
end-class

begin
    vars k, v, w
    k = new Foo
    k.baz(w, v)
    io.print(a)

end

```
> Resultado:
```
    [Erro]: variável 'a' não definida
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


## <Test 10 (Recursão)
> Código:
```
[FATORIAL]

```
> Resultado:
```

```



## <Test 11 (Acessar uma função de um prototype de prototype de um objeto)
> Código:
```
class Foo
    vars x, y

    method temp()
    vars a
    begin
        a = self.x
        io.print(a)
    end-method
end-class

class Bar
    vars a, b
    
end-class


class Baz
    vars x, y

    method qux()
    vars a
    begin
        a = 8001
        io.print(a)
    end-method
end-class


begin
    vars foo, bar, baz
    foo = new Foo
    bar = new Bar
    baz = new Baz

    bar._prototype = baz
    foo._prototype = bar

    foo._prototype = bar
    bar._prototype = baz

    foo.qux()

end


```
> Resultado:
```
    8001
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



## Test 13 (Testes da meta-ação de insert, delete, replace e imprime com o io.dump)
> Código:
```
class Foo
    vars x, y

    method bar(a, b)
    vars k
    begin
        a = self.x
        b = self.y
        k = a + b 
        io.print(k)
        k = k * k
        io.print(k)
    end-method

    method baz(h)
    vars i, j
    begin
        j = self.x
        i = j / h
        io.print(i)
    end-method

end-class

begin
    vars a, b, foo
    foo = new Foo

    io.dump(foo)

    foo.bar()
    foo.baz


end


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


## Test 15 (Atribuição com t)
> Código:
```
begin
  vars a, b, c, d
  a = 10
  b = 20
  c = b + a
  io.print(c)
  c = b * a
  io.print(c)
  c = b / a
  io.print(c)
  c = b - a
  io.print(c)
  c = b + d
  io.print(c)
  c = b * d
  io.print(c)

end

```
> Resultado:
```
    30
    200
    2
    10
    20
    0
```
## Test 16 (Atribuição com soma, com retorno de método, com número, com atributo para atributo)
class Float
  vars decimal
  method getValue()
  vars value
  begin
    value = 10
    return value
  end-method
end-class

begin
  vars float, v, aux, floatA
  float = new Float
  floatA = new Float
  v = float.getValue()
  aux = 5
  aux = aux + v
  io.print(aux)
  floatA.decimal = 10
  float.decimal = 5
  floatA.decimal = float.decimal
  aux = floatA.decimal
  io.print(aux)
end
```
    15
    5
```
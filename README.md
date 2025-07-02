# The Humane Language is for humans, not compilers
By J. Fred Truter, 2025

Language specification is below

## License

See [license](./LICENSE) file

## Extension

This extension for Visual Studio Code provides the following features:-

* Syntax highlighting

## Updated

    2nd July 2025

## Introduction

Previous languages were designed with 'ease of parsing' in mind, hence curly braces around code blocks, and semi colons after each statement. This punctuation is purely for the sake of the parser, and an unwanted chore for the programmer.

Well it is 2025 now and we have very fast CPUs with lots of memory. The speed of parsing is no longer something that the programmer should have to worry about. 

## Design of Zen

Python has a good approach, but can still be improved on because it is somewhat inconsistent, for example:-

python
```
    #NB `list` is a type which has a constructor that takes *element
    foo = 1 # declares an int variable called 'foo'
    class Bar:  # declares a class called 'Bar'
      __init__(self, name: str): # constructor
        pass
    class Bars(list[Bar]): pass # 'Bars' inherits from 'list'
    barsInPhoenix = Bars(
        Bar('Bitter & Twisted Cocktail Parlour'), 
        Bar('Gracie\'s Tax Bar')
    )
```

See how the name Bar isn't at the start of the line? This hampers the programmer's reading speed. All names should be at the very start of the line (but could be indented with spaces in case the statement is inside a code block). A better approach would be like this:-

humane
```
    {NB List is a generic type which has a constructor that takes a class as only argument and returns a new concrete type}
    foo = 1
    Bar = class
      init = (name String)
        return
    Bars = List(Bar)
    barsInPhoenix = Bars(
      Bar('Bitter & Twisted Cocktail Parlour'),
      Bar('Gracie''s Tax Bar')
    )
```

This way if a programmer is looking for a particular declaration or assignment they can visually scan the start of each line of code, with little to no horizontal eye movement, which would be a productivity boost, and a reduction in eye strain.

### Naming rules

Class names and Types should ALWAYS begin with uppercase letters.
Variable names, functions, etc should NEVER begin with uppercase letters.

### Smart compiler

Static code analysis can determine if a piece of code touches asynchronous stuff, and if so, the compiler can automatically mark the calling function as 'asynchronous' and automatically insert 'await' whenever it is called, and so on. The programmer should not have to worry about adding 'async' and 'await'.... 

Traditional programming languages has a lot of boilerplate and rituals. These should be eliminated.

Every statement can throw an exception, but again, the compiler can perform static code analysis to determine what kind of runtime error can be thrown, and in an IDE the statement can be highlighted to alert the programmer that certain exceptions are possible, but not handled explicitly.

Punctuation is generally to be avoided. For example Javascript has a 'swap' pattern

javascript
```
   [a, b] = [b, a]
```

This same action is achieved in Python with less punctuation:

python
```
   a, b = b, a
```

Clearly the latter is more legible, quicker to type, and therefore preferable over Javascript's approach.

Python still requires colons at the end of a line to signal to the parser that a block should follow (which has to be 'more' indented, and consistent number of spaces, than the current block). But python (since version 3) overloads this colon to also separate names from their types. Overloaded symbols should be avoided.

Here is a quick example of the kind of thing that is valid in this new language

humane
```
    fibonacci = (
        { Calculates the `n`-th Fibonacci number }
        n U32 = 0   { index of number in Fibonacci sequence }
    ) -> U32 
        if n <= 2 return n
        fibonacci(n-1) + fibonacci(n-2)   { last expression is automatically returned }

    fifthFibonacci = fibonacci(n = 5)
    tenthFibonacci = fibonacci(10) { we omitted the argument name and rely on argument position }
```

### Compile time evaluation

Some expressions can be evaluated at compile time and baked into the code, e.g. if the programmer writes `bakersDozen = 12+1` that expression `12+1` serves as a reminder of how and why it is 13, but because this expression is constant and the result is computable at compile time, and will be invariant on all platforms, the actual code generated is `bakersDozen = 13`

Static code analysis determines that `bakersDozen` is never mutated and therefore whereever it is referenced, its value will be substituted at compile time, meaning at runtime there won't really be a slot it memory initialised with the value 13.

The same goes for functions that always return the same value... If there is a complicated function which is only ever called  with constant arguments (known at compile time), then there is no need to compile the function and execute it at runtime. The function can be compiled and executed during compile time to obtain the result, and the result can be baked into the compiled program instead of the function itself.

The only time a function needs to be included in the runtime is if it is exported from library that is going to be called in the future by unknown static or dynamic linked callers. Also, if a function is called multiple times with arguments that will only only be known at runtime, then the compiler can't bake the results into the program at compile time and will have to, begrudgingly, emit code into the executable/library to be executed at runtime.

If a class member function does not reference any of the class instance members, or member other functions that do so, then that member function will automatically become 'static' and can be called either from the class name, or from an instance, e.g.

humane
```
    Foo = class
        name String
        bar = () -> String
            'You''ve been foo-barred'  { doesn't reference the instance of Foo }
        upper = () -> String
            name.toUpperCase(invariantCulture) { does reference `this.name` }

    one = Foo(name = 'hello') { allocate space for one Foo and invoke it's synthesized `init`}

    print(one.name)  {prints 'hello'}
    print(one.bar())  {prints 'You've been foo-barred'}
    print(Foo.bar())  {prints 'You've been foo-barred'}
    print(one.upper())  {prints 'Hello'}
    print(Foo.upper())   {raises InstanceMethodCalledOnClassError('`upper` requires an instance of `Foo`')}

    one.name = 'world'
    { calling functions that take no arguments you can omit the braces }
    print(one.name)  {prints 'world'}
    print(one.bar)  {prints 'You've been foo-barred'}
    print(Foo.bar)  {prints 'You've been foo-barred'}
    print(one.upper)  {prints 'World'}
    print(Foo.upper)   {error - upper requires an instance of Foo}
```

## Literals

humane
```
  { 
    I am just a comment 
    which spans multiple
    lines
  }
  iAmAString = 'Hello World' {only single quotes delimit strings}
  anotherString = 'Sophie''s Choice is the best book ever.' {double apostrophe inside a string literal becomes one apostrophe inside the string}
  interpolatedString = 'And the AI said: "{iAmAString}", and everyone laughed.'  {curly braces inside a string cause interpolation}
  iAmAUnicodeChar = "🙂" {double quotes delimitd characters}
  iAmAnInt = -42
  iAmABool = true
  iAmAFloat = 3.1415926e+1
  iAmALargeInt = 1_234 { underscores inside numbers are ignored }
  iAmALargeFloat = 1_234.567_890_123
  iAmAListOfInt = [1, 2, 3, 4]
  iAmAMapOfStringToInt = ['one': 1, 'two': 2, 'three': 3]

```

## Error handling. 

So if the programmer writes a function:-

humane
```
  average = (numerator Float, denominator Float) -> Float
    numerator / denominator
```

Obviously there is a possibility that when it is called with a 0 for the second argument, a division by zero error will occur.

There are several ways to avoid that, but let's deal with it inside `average` function by declaring a fallback:-

humane
```
    average = (numerator Float, denominator Float) -> Float
        numerator / denominator
            except DivisionByZero Float.nan {explicitly return NaN}
```

But did you know that very small non-zero values for the denominator will cause positive or negative infinity which will be an Overflow exception. So let's deal with those:-

humane
```
    average = (numerator Float, denominator Float) -> Float
        numerator / denominator
            except DivisionByZero Float.nan {explicitly return NaN}
            except Overflow
                if denominator < 0 return -Float.infinity
                else return Float.infinity 
```

Catching an exception on every line is tedious, especially if you have a lot of similar lines and the response is going to be the same no matter which line the error occurred on. In other languages you have try/catch patterns, e.g.

csharp
```
    try {
        a = b / c;
        d = a / b;
        e = d / c;
    } catch {
        return double.NaN;
    }
```

humane
```
    do
        a = b / c
        d = a / b
        e = d / c

        except return Float.nan
```

Here `except` is directly indented within the `do` block and acts as a catch-all for any exception in the block.

The following is *invalid* because the parser expects an optional exception type (all exception types inherit from `Error`) but instead it found another type, which the programmer intended to be the substituted value

humane
```
    except Float.nan { compile error: Expected a type after `except` but got an instance instead }
```

Here are some valid alternatives:-

humane
```
    except Error return Float.nan
    except Error 
        Float.nan
    except
        Float.nan
    except return Float.nan
```

The programmer can declare arbitrary exception types:-

humane
```
    KitchenProblem = Error
        reason String
    KitchenOnFire = KitchenProblem
    KitchenClosed = KitchenProblem
```

Using these types are easy:-

humane
```
    do
        if kitchenSmokeDetected
            KitchenOnFire(reason = 'Smoke detector')
        if kitchenTemperature > 90
            KitchenClosed(reason = 'Too hot for humans')
        except error KitchenProblem
            print('Problem in the kitchen {error.reason}')
```

Creating an instance of an Error (or descendant) automatically exits that block of code, akin to other programming languages' `throw` or `raise` keywords. This way if smoke is detected, then that is the only error that will be printed, as the statement below it which tests the temperature won't be executed.

humane
```
  Car = class
    registration String
    colour String
    make String
    init(registration String, colour String?, make String?)
      this.registration = registration
      this.make = make | ''
      this.colour = colour | ''
    ->String
      '{registration} {colour} {make}'.trimmmed

  myMonster = Car('LD21MON', 'blue', 'Ford')
  print(myMonster)   {prints 'LD21MON blue Ford' by calling `String` converter}
```

## Argument aliases

The Swift language allows one to give arguments two names; an outward facing one (which the caller should use) and an internal one that is used in the body of the function. This is very useful to make the calling code more readable. The alias names could be keywords, but at the call site the alias name is resolved first by the parser, e.g.

humane
```
  microwave(
    jobName String?,
    `for` phase1Time Duration, 
    `at` phase1Power Power?,
    `stand` Duration?,
    `then` phase2Time Duration,
    `at` phase2Power Power?
  )
    return {...implementation omitted for brevity}

  {note that Minutes inherits from Duration, and Watts from Power}

  {call example with commas on one line}
  microwave('Potatoes', for Minutes(5), at Watt(800), stand Minutes(1), then Minutes(4), at Watt(600))

  {call example with block arguments}
  microwave(
    'Potatoes'
    for Minutes(5)
    at Watt(800)
    stand Minutes(1)
    then Minutes(4)
    at Watt(600)
  )

  {call example using syntactic sugar to enhance readability}
  microwave('Potatoes' for 5 Minutes at 800 Watt, stand 60 Seconds, then 4 Minutes at 600 Watt)
```

Notice how in the last call example there are still some commas, but they are optional and the programmer only included them because it helps to make the line read like an English sentence. Also noticce how the `for` keyword was overriden to be an argument alias.

## Syntactic sugar at call sites

When an expression is followed by a type name, and there exists a constructor for that type which has only one argument which matches the kind of the preceding expression, then the compiler will convert `expression Type` to `Type(expression)`. In other words, it will call the type's `init` with the preceding expression's result as argument.

## Abstract types

`Duration` and `Power` are both good examples of abstract types. They can store a value, but the value is meaningless without a unit of measure. The implementor has the flexibility to decide what that value represents internally, but the caller/user of this can't access the value directly; only through derived types like `Minutes` `Seconds` and `Watts` / `Horsepower`. Here's how one could declare something like this in Humane:

humane
```
  Duration abstract Float
    seconds() Float this
    minutes() Float this / 60
    hours() Float this / 60 / 60
    days() Float this / 60 / 60 / 24

  Seconds Duration init(seconds Float) base(seconds)
  Minutes Duration init(minutes Float) base(minutes * 60)
  Hours   Duration init(hours   Float) base(hours * 60 * 60)
  Days    Duration init(days    Float) base(days * 60 * 60 * 24)

  print('One day is {Days(1).seconds} seconds')  {prints "One day is 86400 seconds"}
  print('Two days have {Days(2).minutes} minutes')  {prints "Two days have 2880 minutes"}
```

## Primitive types

humane
```
  Bool = enum U8
    false = 0
    true > 0 default 1

  Number = abstract class
    zero = static This(0)

    {The follow abstract static methods must be implemented by derived types}
    minPositive = static () -> This 
    maxPositive = static () -> This 
    minNegative = static () -> This
    maxNegative = static () -> This
    nextLargerNumber = () -> This
    nextSmallerNumber = () -> This
    bitCount = static () -> This

  FloatingPointNumber = abstract class Number
  F8 = class FloatingPointNumber {IEEE 754-inspired 1-4-3 format}
    minPositive = static () -> This 0.001953125
    maxPositive = static () -> This 240
    minNegative = static () -> This -0.001953125
    maxNegative = static () -> This -240
    nextLargerNumber = () -> This NotImplemented
    nextSmallerNumber = () -> This NotImplemented
    bitCount = static () -> This 8

  F16 = class FloatingPointNumber {IEEE 754-half precision 1-5-10 format}
    minPositive = static () -> This 2 ^ -24
    maxPositive = static () -> This 65504
    minNegative = static () -> This -2 ^ -24
    maxNegative = static () -> This -65504
    nextLargerNumber = () -> This NotImplemented
    nextSmallerNumber = () -> This NotImplemented
    bitCount = static () -> This 16

  F32 = class FloatingPointNumber {IEEE 754-normal precision 1-8-23 format}
    minPositive = static () -> This 2 ^ -149
    maxPositive = static () -> This 3.402823466385288598117041834845169254e38
    minNegative = static () -> This -2 ^ -149
    maxNegative = static () -> This -3.402823466385288598117041834845169254e38
    nextLargerNumber = () -> This NotImplemented
    nextSmallerNumber = () -> This NotImplemented
    bitCount = static () -> This 32

  F64 = class FloatingPointNumber {IEEE 754-double precision 1-11-52 format}
    minPositive = static () -> This 2 ^ -1074
    maxPositive = static () -> This 1.7976931348623157e308
    minNegative = static () -> This -2 ^ -1074
    maxNegative = static () -> This -1.7976931348623157e308
    nextLargerNumber = () -> This NotImplemented
    nextSmallerNumber = () -> This NotImplemented
    bitCount = static () -> This 64

  F80 = class FloatingPointNumber {IEEE 754-extended precision 1-15-64 format}
    minPositive = static () -> This 2 ^ -16508
    maxPositive = static () -> This 3.940468503986436150e4931
    minNegative = static () -> This -2 ^ -16508
    maxNegative = static () -> This -3.940468503986436150e4931
    nextLargerNumber = () -> This NotImplemented
    nextSmallerNumber = () -> This NotImplemented
    bitCount = static () -> This 64

  F128 = class FloatingPointNumber {IEEE 754-quad precision 1-15-112 format}
    minPositive = static () -> This 1.026e−4967
    maxPositive = static () -> This 1.7026e4932
    minNegative = static () -> This -1.026e−4967
    maxNegative = static () -> This -1.7026e4932
    nextLargerNumber = () -> This NotImplemented
    nextSmallerNumber = () -> This NotImplemented
    bitCount = static () -> This 64

  Float = F64
  {NB `Float` is an alias for whichever of F8...128 is "natural" on the current CPU, typically F64 at the time of writing (2025)}

  UnsignedInteger = abstract class Number
  U8 = class UnsignedInteger
  U8 = class UnsignedInteger
  U16 = class UnsignedInteger
  U32 = class UnsignedInteger
  U64 = class UnsignedInteger
  U128 = class UnsignedInteger
  UInt = U64
  {NB `UInt` is an alias for whichever of U8...128 is "natural" on the current CPU, typically U64 at the time of writing (2025)}

  SignedInteger = abstract class Number
  I8 = class SignedInteger
  I8 = class SignedInteger
  I16 = class SignedInteger
  I32 = class SignedInteger
  I64 = class SignedInteger
  I128 = class SignedInteger
  Int = I64
  {NB `Int` is an alias for which ever of I8...128 is "natural" on the current CPU, typically I64 at the time of writing (2025)}

  Date = abstract class

  Date16 = class Date {from 1950 through 2130, accuracy one day}
  Date32 = class Date {up to 5889 years in the past or future, accuracy one day}
  Date64 = class Date {up to 25E15 years in the past or future, accuracy one day}

  Time = abstract class
  Time16 = class Time {up to one day, accuracy 1.32 seconds}
  Time32 = class Time {up to one day, accuracy 20.11 microseconds}
  Time64 = class Time {up to one day, accuracy 4.68 femtoseconds}

  Moment = abstract class Date, Time
  Moment32 = class Moment 
      date Date16
      time Time16
  Moment64 = class Moment 
      date Date32
      time Time32
  Moment128 = class Moment 
      date Date64
      time Time64
```

You will be surprised to learn that neither Date nor Moment implement `era`, `yearOfEra`, `quarterOfYear`, `monthOfYear`, `monthOfQuarter`, `weekOfYear`, `weekOfMonth`, `weekOfQuarter`, `dayOfYear`, `dayOfMonth`, `dayOfQuarter`, `dayOfWeek`, `hour`, `minute`, `second` and `fraction` as properties, because their values depend entirely on the calendar being used and the time zone, therefore these are member _functions_ which take a calendar and a time zone as argument.

All the calendar components are unsigned integers, except `year` which is signed, and `fraction` which is the largest Float type available on the current CPU. Typically this is F64. `fraction` ranges from 0 to just less than 1. All calendar components have accompanying static enquiry functions `getRangeOfXXXX` e.g. `getRangeOfWeek(calendar Calendar?, era Int?, year Int?, quarter Int?, month Int?) Range(UInt)` For these functions if calendar is omitted the user or system's default calendar is used. If other arguments are omitted, then the widest possible range is returned, e.g. some years in the Gregorian calendar have week numbers from 0 to 53 others from 1 to 54, so without knowing which year, the returned range will be 0...54

## Modules

Large complicated codebases can be organised into modular groups. These can be iterated on independently by different programming teams. Some of these modules are external to your organisation and may be closed or open source.

Humane comes with a package manager built into the compiler.

### Import local modules

Each module resides in a sub-folder from the current one. Remember you can create symbolic links in the file system to make distant folder appear to be direct descendants of the current one.

humane
```
    SomeLocalModule = import { expects a folder ./SomeLocalModule and a file inside it called `module.hum` }
```

#### Alias names for imports

In python it is traditional to import Numpy but call it `np` instead:-

python
```
    import numpy as np
```

When you import a local module by name, you can still rename it in one step:-

humane
```
    np = numpy = import { imports `module.hum` from ./numpy }
    numpy = undefined { forget you ever saw `numpy` }
```

### Import a module from some other local folder

humane
```
    SomeLocalModule = import '../../vendors/Microsoft/AI/Copilot' { expects a folder ../../vendors/Microsoft/AI/Copilot and a file inside it called `module.hum` }
```

### Import a module from a remote git repository

humane
```
    SomeRemoteModule = import 'git@bitbucket.org:team/project.git' { expects the team to publish at least `module.hum` in the root }
```

### Import a standard module

humane
```
  Math = import
```

### Import only some members from any source

Demonstrating it with the math library

humane
```
  min, max, floor, squareRoot as √ = import Math
  print('The square root of 25 is {√(25)}')
```

### Import a module from a remote git repository but only a specific version

humane
```
    SomeRemoteModule = import 'git@bitbucket.org:team/project.git' until '1.x' 
    { expects the team to publish at least `module.hum` in the root and maintain seperate version branches }
```

The compiler will enumerate all the branches on the repository that start with "1." and pull down the latest one into a local folder `.imports/bitbucket/team/project/1.2` if that folder doesn't already exist.

### Import a standard C header

humane
```
    Brotli = import 'brotli.h'
```

When an import is a simple file with .h or .hh extension Humane will search the current folder for that file, or look for it inside a sub-folder called Brotli or just brotli, and failing that it will look at all the folders listed in the following environment variables (like gcc):-
* CPATH
* C_INCLUDE_PATH ¶
* CPLUS_INCLUDE_PATH ¶
* OBJC_INCLUDE_PATH

The compiler will synthesize a bridging header called 'brotli.hum' wherin it declares Humane versions of all the functions and structs it finds inside 'brotli.h' And when it detects that the synthesized version is older than the library it replaces, it will recreate it on the fly.


### module.hum

This file tells the compiler what is inside the module that can be used from outside, and it is written in Humane itself.

humane
```
    Module, Executable = import PackageManager_v1
    Class1,Enum2,PI,Graphics = import
    topLevelCode = import 'main.hum'

    Module(
      author = 'Idiot Number One',
      exports = [
          Class1,
          Enum2,
          Graphics,
          PI,
      ],
      generateCHeader = 'antipesto.h',
      name = 'Antipesto',
      version = '1.3.1',
      warning = 'This version has a serious security flaw and should not be used. Upgrade to 1.4.0 as soon as possible',
    )

    Executable(
      author = 'Acme Corp',
      copyright = '(C) 2025 Acme Corp',
      license = 'MIT',
      main = topLevelCode,
      version = '1.4.2',
    )

    Tests(
      parallelism = 10,
      prerequisites = [
        Server(
          executable = './testServer/start', 
          arguments = [
            ('port', 8443),
            ('host', '0.0.0.0')
          ],
          monitorPort = 8443,
          terminateOnCompletion = true
        )
      ],
      redirects = {
        'https://acmecorp.com/api': 'http://localhost:8443'
      },
    )
```

The only symbols that can be imported from the `antipesto` module are listed in the `exports` list. Somewhere inside the module there must be a .hum file which declares Class1 and somewhere Enum2, PI and somewhere Graphics. These things can be constants, classes, enums and so on.

### Dereferencing module exports

Following on from the previous example `module.hum` we can import that, assuming it was in a sub-folder "./blah" or "./Blah"

```
    Blah = import

    print(Blah.PI)
    print(Blah.Graphics.dpi)
```

## Statements

### `for` .. `in`

This statement follows this pattern:-

ebnf
```
  "for" , block-scoped-name , "in" , enumerable-expression , statement ;
  "for" , block-scoped-name , "in" , enumerable-expression ,
    indent , 
      { statement | "break" | "continue" } ,
    dedent 
  ;
```

### `do` ... `while`

This statement follows this pattern:-

ebnf
```
  "do" , "while" , condition , statement ;
  "do" , "while" , condition , 
    indent ,
      { statement | "break" | "continue" } ,
    dedent
  ;
```

OR

ebnf
```
  "do" , 
    indent , 
      { statement | "break" | "continue" } , 
      "while" , condition
    dedent ;
```

### `do` ... `until`

This statement follows this pattern:-

ebnf
```
  do-until-statement = do-until-line | do-until-block ;
  do-until-line =
    "do" , statement , "until" , condition 
  ;
  do-until-block =
    "do" , 
    indent ,
      { statement | "break" | "continue" } , 
      "until" , condition
    dedent 
  ;
```

### `if`, `elif` and `else`

This statement follows this patterns:-

ebnf
```
  if-statement = if-multiline | if-one-line ;

  if-multiline = 
    "if" , condition , 
      indent, 
        { statement } , 
      dedent , 
    { "elif" , condition , 
      indent, 
        { statement } , 
      dedent 
    } ,
    [ "else" , 
      indent, 
        { statement } , 
      dedent 
    ]
  ;

  if-one-line = 
    "if" , condition , (statement | expression) , 
    { "elif" , condition , (statement | expression) } , 
    [ "else" , (statement | expression) ]
  ;
```

### Range expressions

Start and end are included in the range, stride must be integer.

ebnf
```
    range-expression = 
      start-expression , [ ":" , stride , ] ":" , end-expression ;
    
    start-expression = expression ;
    stride = integer ;
    end-expression = expression ;
```

humane
```
    Range = abstract over Stridable
      start This
      stride Int
      end This?
```

A range without an `end` value is an open range and can be specified by omitting the value after the colon, e.g. `100:` which implies all integers greater than or equal to 100. While `51:2:` implies all odd integers greater than or equal to 51.

A range can be constructed over any type that implements Stridable interface.

humane
```
    Stridable = abstract class
      next = (after This, step Int = 1) This?
```

#### Syntactic sugar `for` loops

humane
```
    for x in 0:2:8
      print(x)   { prints "0", "2", "4", "6" and "8" on separate lines }
```

#### Syntactic sugar if `in` and `not in`

humane
```
    if marks in 0:50 print('fail')
    if marks not in 0:100 InvalidData('marks should be between 0 and 100 only')
```

### Generators

Generator functions `yield` values. The one below yields a countdown to 0.

humane
```
    countDown = (`from` start Int, `to` end Int = 0, `by` step Int = -1) Int...
      for x in start:by:end
        yield x

    { usage example prints "5", "4", "3", "2", "1", and "0" on separate lines one second apart }
    for x in countDown(5)
      print(x)
    sleep 1 Seconds
```

Note how the function's return type has an ellipsis suffix. This is syntactic sugar for the Sequence interface. Behind the scenes the compiler replaces `Type...` with `Sequence(of Type)`

Generators can yield infinite sequences. Previously we implemented `fibonacci` as a recursive function taking arguments. Now we reimplement it as an infinte sequence. It is the caller's responsibility to exit the loop and stop asking for the next value!

humane
```
    fibonacci = () UInt...
      a UInt = 0
      b UInt = 1
      
      yield a
      yield b
      do
        a, b = b, a+b
        yield b
        continue

    { usage example }
    for x in fibonacci
      if x in 100:200
        print(x)
      if x > 200
      break { prevents infinite recursion }
```

## Variables v constants

bnf
```
    variableName TypeName ["=" ["private"] ["const"] [valueExpression]  ["in" rangeExpression]] ["[" * "]"]
    variableName "=" ["private"] ["const"] valueExpression ["in" rangeExpression] ["[" * "]"]
    variableName "=" ["private"] ["const"] "in" rangeExpression ["[" * "]"]
```

In the first form above the type of the variable is directly specified.
In the second form the type is omitted but inferred from the valueExpression's type.
In the third form the type is inferred from the rangeExpression's type

When the keyword `private` is present then the variable will not automatically escape its block to become a static reflected property of the block, which happens when static code analysis determines that a variable is invariant. The block can be a class, enum or function.

When the keyword `const` is present then the variable will be marked as invariant, and any attempt to alter its value will result in InvarianceViolation('{variable} is declared `const`')


### Range limits

humane
```
    age Int in 16:  { minimum age is 16, no maximum (open range) }
    marks Float in 0:100  { test result range is closed }
    passMarkRange = 50:100
    distinctionMarkRange = 75:100

    marks = 60 { valid assignment because 60 is in 0:100 }
    marks = -1 { throws compile time exception Underflow('-1 for `marks` is outside 0:100 range') }
    marks = 100.1 { throws compile time exception Overflow('100.1 for `marks` is outside 0:100 range') }

    for i in random(-1000:1000)
      marks = i  { will probably throw a runtime exception Underflow or Overflow }
```

## Functions

We have already covered ordinary functions, generators, arguments, aliases, default values, and only need to mention that function arguments can have range limits just like variables. These limits are checked when the function is called and Overflow / Underflow errors are thrown either at compile time, or runtime at the call site. The function will never even be called with invalid arguments. This is the way.

### Reflection

The range limits and other properties of the arguments are available via reflection on the function itself.

humane
```
    taxCalculator = (
      income Float in 0: { per annum },
      age Int in 16: { whole years since birth },
      isVeteran Bool
    ) Float in 0:income { they can't take more than you earn! }
      
      { the compiler sees the following declarations are constant and will mark them static as well as publish them as properties of the function itself }

      youngPersonRange = 16:19
      pensionerRange = 65:
      band1IncomeRange = 0:20_000
      band2IncomeRange = 20_000:40_000
      band3IncomeRange = 40_000:100_000
      band4IncomeRange = 100_000:

      { these ones are marked as `private` so won't be published }
      band1TaxRate private Float = 0
      band2TaxRate private = 0.2
      band3TaxRate private = 0.4
      band4TaxRate private = 0.5
      pensionerDiscount private  = 0.25 { pensioners still getting an income pay only 75% of the usual tax }
      youngPersonDiscount private = 0.5 { young people pay half the usual tax }
      veteranDiscount private = 0.1 { ex-defence force service members pay only 90% of the usual tax }

      usualTax = min(income, band1IncomeRange.end) * band1TaxRate
      if income in band2IncomeRange
        usualTax += (min(income, band2IncomeRange.end) - band1IncomeRange.end) * band2TaxRate
      if income in band3IncomeRange
        usualTax += (min(income, band3IncomeRange.end) - band2IncomeRange.end) * band3TaxRate
      if income in band4IncomeRange
        usualTax += (income - band3IncomeRange.end) * band4TaxRate

      if age in youngPersonRange
        usualTax *= (1 - youngPersonDiscount)
      elif age in pensionerRange
        usualTax *= (1 - pensionerDiscount)

      if isVeteran
        usualTax *= (1 - veteranDiscount)

      return floor(usualTax) { government doesn't care about pennies }

    age = ask('What is your age?', type = taxCalculator.age.type, range = taxCalculator.age.range)
    if age in taxCalculator.youngPersonRange
      print('...lucky you''re so young as you will be paying less tax than most people')
    elif age in taxCalculator.pensionerRage
      print('...luckily you have earnt the right to pay less tax than younger people')
    else
      print('...unlucky, you must subsidise everyone else')

    income = ask('How much do you earn per year?', taxCalculator.income.type, taxCalculator.income.range)
    if income in taxCalculator.band1IncomeRange
      print('...that puts you in income band 1')
    elif income in taxCalculator.band2IncomeRange
      print('...that puts you in income band 2')
    elif income in taxCalculator.band3IncomeRange
      print('...that puts you in income band 3')
    else 
      print('...that puts you in income band 4')

    isVeteran = ask('Have been honorably discharged from the armed forces, fire service or police?', Bool)
    if isVeteran
      print('...lucky, you will get a tax discount')

    { This will throw a compile time exception VariableUnknown('band4TaxRate') because it is private }
    print('The highest earners pay {taxCalculator.band4TaxRate * 100}% on their income')

    { This will throw a compile time exception VariableUnknown('band4TaxRate') because it is variant }
    print('The usual tax someone pays is {taxCalculator.usualTax}')

    taxDue = taxCalculator(income, age, isVeteran)

    for arg in taxCalculator.arguments
      print('{arg.name} is {arg.type} in {arg.range} {arg.comment}') 
    { prints
    
      "income is Float in 0: per annum"
      "age is UInt in 16: whole years since birth"
      "isVeteran is Bool"
    }

    for item in taxCalculator.constants
      print('{item.name} is {item.type} = {item.value} {item.comment}') 
    { prints

      "youngPersonRange is Range(of Int) = 16:19"
      "pensionerRange is Range(of Int) = 65:"
      "band1IncomeRange is Range(of Int) = 0:20000"
      "band2IncomeRange is Range(of Int) = 20000:40000"
      "band3IncomeRange is Range(of Int) = 40000:100000"
      "band4IncomeRange is Range(of Int) = 100000:"
    }
```

As can be seen from the example above, each function has a property `constants` which is of type `Sequence(of ConstantValue)`. It is therefore forbidden to name an argument `constants`.

It also has an `arguments` property which is of type `Sequence(of Variable)`. And also forbidden to name an argument `arguments`.

You cannot declare two variables (and here arguments count as variables) with the same name. The second declaration will raise a compile time exception NameClash('{variable} has already been declared in this block')

### Trailing dragnet for variable number of arguments

bnf
```
  sp = UNICODE_WHITESPACE 
  variableName = UNICODE_LOWER_CASE_LETTER IDENTIFIER_SYMBOL*
  typeName = UNICODE_UPPER_CASE_LETTER IDENTIFIER_SYMBOL*

  commentText = \[^\]]*\
  comment = sp* "[" commentText "]" sp*
  help = comment
  expression = # TODO

  rangeStart = expression
  rangeStep = expression
  rangeEnd = expression
  rangeExpression1 = rangeStart sp* ":" sp* rangeStep sp* ":" sp* rangeEnd
  rangeExpression2 = rangeStart sp* ":" sp* rangeEnd
  rangeExpression3 = rangeStart sp* ":" 
  rangeExpression = rangeExpression1 | rangeExpression2 | rangeExpression3
  argumentRange = sp+ "in" sp+ rangeExpression

  defaultExpression = expression
  argumentDefault = sp* "=" sp* defaultExpression

  argumentName = variableName
  argumentType = typeName
  argument1 = argumentName sp+ argumentType [argumentRange] [argumentDefault]
  argument2 = argumentName sp+ argumentType "?" [argumentRange]
  argument3 = argumentName argumentRange [argumentDefault]
  argument4 = argumentName "?" argumentRange
  argument5 = argumentName argumentDefault
  argument = (argument1 | argument2 | argument3 | argument4 | argument5) [help]
  argsList = sp* argument ( ["," sp* argument] ) *

  tailType = argumentType
  argumentTail = sp* "," sp* argumentName sp+ tailType "..." [argumentRange]
  argumentDragnet = sp* "," sp* argumentName "..."
  
  functionName = argumentName
  function = functionName sp* "=" sp* ["private"] sp* "(" [help] [argsList] [argumentTail] [argumentDragnet] sp* ")" typeName ["..."]
```

The tail argument is akin to python's `*` which collects all unnamed arguments from that point onwards. In Humane the type of the tail must be specified and is turned into `Sequence(of tailType)`.

The dragnet argument is akin to python's `**` which collects all remaining named arguments (where the names do not match arguments specifiec in `argsList`). In Humane the type of this argument is `Map(key String, value Any)`

## Classes

Classes can act as containers for static functions, if there are no member variables and therefore no in-memory storage allocation. It is a compile time error to attempt to create a new instance of such a class.

Classes can be abstract, optionally with member variables common to all derived types. Such classes can provide static function implementations as well as default implementations for instance methods. Such methods can be overriden in derived types, where the base class' method can be reached via `base.`

### Any class

Every class eventually inherits from Any. Be careful when working with these because at runtime they will need to be boxed in a behind-the-scenes structure which contains a reference to or copy of the value, and a reference to its type. This is an overhead which strong typing should overcome if it is used properly.

The compiler should have an optional setting to tell it how to treat occurrences of `Any` in source code; ignore, warn (default), or throw exception.

You can't directly work with an instance of `Any` but have to guess at its type:-

humane
```
    Bar = Any
    myFunction = (foo Bar) Bar
      if foo is Stridable
        return foo.next
      if foo is Numeric
        return -foo
      if foo is String
        return 'Can you explain a {foo}?'
      'What did you think I should do with a {type(foo)} of {foo}??'

    {examples}
    myFunction(4)  {returns 5 because Int is stridable}
    myFunction("a")  {returns "b" because Char is stridable}
    myFunction(4.2)  {returns -4.2 because Float is Numeric}
    myFunction('man')   {returns 'Can you explain a man?'}
    myFunction(true)    {return 'What did you think I should do with a Bool of true??'}
```

It is important to note that here `type(foo)` has to be executed at runtime, where as usually something like `type(1)` is executed at compile time.

### `match` expression

The previous `myFunction` can be written more succinctly as

humane
```
    Bar = Any
    myFunction = (foo Bar) Bar { compiler warning UseOfAnyType('Bar') }
      match type(foo)
        Stridable => foo.next
        Numeric => -foo
        String => 'Can you explain a {foo}?'
        other => 'What did you think I should do with a {other} of {foo}??'
```

In this example the variable `other` catches all other types and when interpolated inside the string, that type's to-String converter will be called to print its name.

The match expression pattern works on other things too, no just types. But what makes type matching special is that after the `=>` operator the compiler knows what type `foo` is, and can resolve `.next` as something implemented by all `Stridable` classes, and `-` negation as something implemented by all `Numeric` classes, etc.

## Concurrency

Imagine there is a `fetch(url String) Response` function and we want to use this to make three API calls. This is a real chore in C#.

csharp
```
    function async myFunction(string url1, string url2, string url3) {
        var result1 = new Dictionary<string, object>();
        var result2 = new Dictionary<string, object>();
        var result3 = new Dictionary<string, object>();
        try {
          var response1 = await fetch(url1);
          if (reponse1.statusCode != 200) 
            throw new WebClientException($"{url1} - {response1.reason}");

          result1 = await JsonSerialiser.TryParse(await response1.Content());

          var response2 = await fetch(url1);
          if (reponse2.statusCode != 200) 
            throw new WebClientException($"{url2} - {response2.reason}");

          result2 = await JsonSerialiser.TryParse(await response2.Content());

          var response3 = await fetch(url1);
          if (reponse3.statusCode != 200) 
            throw new WebClientException($"{url3} - {response3.reason}");

          result3 = await JsonSerialiser.TryParse(await response3.Content());

        } catch (WebClientException ex) {
          print(ex.Message);
          return combined;
        } catch (JsonParsingException ex) {
          print(ex.Message);
          return combined;
        }
        var combined = new Dictionary<string, object>();
        combined["1"] = result1;
        combined["B"] = result2;
        combined["three"] = result3;
        return combined;
    }
```

Here the three asynchronous calls are done in series, which means all their latencies add up to the latency of the entire function.

humane
```
  myFunction = (url1 Url, url2 Url, url3 Url) JsonMap
    do
      response1 = fetch(url1)
        except not response1.ok 
          return WebClientException('{url1} {response1.reason}')
      response2 = fetch(url2)
        except not response2.ok 
          return WebClientException('{url2} {response2.reason}')
      response3 = fetch(url3)
        except not response3.ok 
          return WebClientException('{url3} {response3.reason}')
      except WebClientException
        print(error)
        return {:}
    
    do
      result1 = response1.content().jsonDecode()
      result2 = response2.content().jsonDecode()
      result3 = response3.content().jsonDecode()

      except
        print(error)
        return {:}

    {
      '1': result1,
      'B': result2,
      'three': result3
    }
```

Here are two `do` blocks. Each block declares three variables where the initial value is the result of an asynchronous function call. The compiler will automaticall start all three of those async tasks simultanously and await their results at the end of the block. Not only is `fetch` async, but so too is `content` and `jsonDecode`. This is called "implicit" concurrency.

## Optional values

We have already alluded to the familiar `Type?` syntax but this is just syntactic sugar and is replaced with `Optional(of Type)` by the compiler.

humane
```
  Optional = class over T HasDefault
    hasValue Bool = false
    value T = T.default

    assign = (value T | null) This
      this.hasValue = value != null
      if this.hasValue
        this.value = value

    `=` = operator(lhs This, rhs T) This
      lhs.assign(rhs)

    conditionalAssign = (value T) This
      if not hasValue
        this.value = value
      return this

    `?=` = operator(lhs This, rhs T) This
      lhs.conditionalAssign(rhs)

    valueOr(alternative T) T
      if hasValue return value
      alternative

    `??` = operator(lhs This, rhs T) T
      lhs.valueOr(rhs)

  {usage example}
  a Int? = 1
  a = 2
  a = null
  if a.hasValue
    print(a.value)
  else
    print(a.value) { raises compile time exception because print wants non-nullable types }
  
  {quality of life improvement with syntactic sugar}
  a = 2
  if a?
    print(a) {`a` is `Int` here, from `a.value` befofe, so prints "2"}
    a = 1 { changes a.value }
  print(a ?? 0) {`a` is an `Optional(of Int)` here, so prints "1"}

```

### Parallelism 

You can force certain things to happen at the same time by using a `parallel` block instead of `do`

Threads will be started to form a worker pool, and statements inside the parallel block will be thrown into the pool for eventual execution.

humane
```
  parallel
    pi = calcPI(to 25 {decimal places})  { long running task }
    sin30 = calcSin(30 Degree to 25 {places}) { another long running task }

    sum = pi + sin30 { implicitly Join's both threads for pi and sin30 }
```

Here the programmer doesn't need to worry about tracking threads in a pool and which CPU core is least busy nor about the mechanics of starting and joining a thread to obtain the results. The only requirement is exclusivity of data ownership. Two parallel tasks can read the same data at the same time so long as neither of them modifies it. If even one task modifies the data sent to it, then both tasks will receive _copies_ of the data. The compiler performs static code analysis to determin ahead of time whether data races are likely, and will clone data where necessary.

If one task modifies the data and the others do not, then the modifications made will be visible to the calling code _after_ conclusion of the `parallel` block. Meanwhile the other tasks in that block will only see the original un-modified data.

If more than one task modifies the data passed into it, then all tasks will receive their own copies of the data, and no modifications will be visible after the end of the `parallel` block.

humane
```
  car = Car(topSpeed=100 MPH, Colour.blue)
  parallel
    car.topSpeed = MPH(200) { this task changes the speed }
    car.colour = Colour.red { this task changes the colour }
  print(car) { prints 'Car(100 mph, blue)' which is the original }
```

## Unit tests

humane
```
  test 'Test identity for integer division'
    a = random(1:1e6)
    assert 1 == a / a { prints nothing }
    assert 2 == a / a { prints 
    '✗ Test identity for integer division failed'
    '  2 != a / a where a == {a}'
    }
```

The failure message automatically inverts the assertion operator. 
* `<` becomes `>=`
* `>` becomes `<=`
* `==` becomes `!=`
* `!=` becomes `==`
* `is` becomes `is not`
* etc


## Unicode

Standard operators are equivalent with their Unicode counterparts. It is advised that IDEs automatically replace the standard operators with their fancy uniccode counterparts, but display the replaced code as a tooltip when hovering over the replacement character.

* `=` and `≔` (colon equals \u2254)
* `==`, `🟰` (equals sign \u1F7F0), `⩵` (\u2a75), `＝` (\uFF1D)
* `!=` and `≠` (\u2260)
* `<=` and `≤` (\u2264)
* `>=` and `≥` (\u2265)
* `|` and `∣` (\u2223)
* `*` and `×` (\ud7)
* `/`, `∕` (\u2215) and `÷` (\uf7)

The following are considered equivalent by the compiler but it is not recommended that the IDE automatically replace these.

* `-` and `−` (\u2212)
* `and` and `∧` (\u2227)
* `or` and `∨` (\u2228)
* `not` and `¬` (\uac)
* `inf` and `∞` (\u221e)
* `assert` and `⊦` (\u22a6)

## Compiling

bash
```
  cd myProject

  # if the project produces an executable, build for release and run
  hum run [arguments...]
  hum --timeit run [arguments...]
  hum --log 'errors.txt' run

  # or just build it to see errors and warnings
  hum build

  # build for another platform
  hum build --cpu arm64 --os linux # find executable in ./.bin/arm64/linux/myProject 
  hum build --cpu x64 --os windows # find executable in ./.bin/x86/wiwndows/myProject 

  # run unit tests and override settings in module.hum's Tests declaration
  hum test --parallelism 10 \
    --redirect 'https://myserver.com/api' 'http://localhost:8834'

  # build for debugging
  hum --debug build

  # build for debug, then start a session using some installed debugger
  hum debug gdb
  hum debug strace edb-debugger
  hum debug vsc
  hum debug lldb

  # cleanup ./.bin and ./.obj folders
  hum cleanup

```


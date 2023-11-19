# Sed preprocesser
This file was processed by the very sed script hosted in this repo. 
Its syntax will be documented here. You should check the unprocessed version too, or else this will not make much sense.

The main functionality of this sed script is the declaration and substitution of variables. For this purpose there is an evaluator symbol, which can be one or more characters long. By default it is `$`. It can be redeclared anywhere in the processed file(s). 
# Assignment
Values can be assigned to variables with the following syntax:
```
EVALUATOR_SYMBOL variable_name = value
```
All the whitespaces represented here may contain any number of spaces or tabs except for the one before value. There a single whitespace character is optionally consumed, but anything more than that will be stored in the variable.
Example:
```
$var = A variable's value can contain spaces. 
```
A variable may be evaluated as
```
EVALUATOR_SYMBOLvariable_name
```
Example:
```
$var
```
evaluates to
```
A variable's value can contain spaces.
```
The evaluator symbol can be changed by setting the SED_EVALUATOR_SYMBOL variable's value. (This has been done in the unprocessed version up until now so as not to evaluate the dollar signs so far.)
Example: 
```
$SED_EVALUATOR_SYMBOL=@
```
From this point on variables with $ in front of them will not be expanded. @ will be used for expansion. You can make this as long or shor as you wish. It may also contain whitespace characters.

Assignemnts following any text will leave the text alone. 
As you can see.

# The interesting part

Some more weird stuff also works.

Multiple layers of evaluation may be used. 
```
$var1 = 2
$var2 = var1
$var2
$$var2
```
will output
```


var1
2
```
Variables are expanded before assignment.

```
$var1 = 2
$var2 = $var1
$var2
$$var2
```
gives
```


2
$2
```

Variables may store valid commands which may be executed by prefixing them with the evaluator symbol again. This can be used to delay execution.
```
$v1 = v2 = this works as expected
$v2
$$v1
$v2
```
Results in:
```

$v2

this works as expected
```

The following also works
```
$v2 = v2 = this works as expected
$$v2
$v2
```
Results in:
```


this works as expected
```

# Notes
If you do not wish to break the script in any way be careful whenever declaring any variables starting with SED_. The only two such value that are intended to be used and relied upon are `SED_PREPROC_VER` and `SED_EVALUATOR_SYMBOL`. SED_PREPROC_VER always expands into the current version fo the sed preprocessor script.

# DebuggableASTInterpreter
An AST interpreter that accepts stepping operations

# Installation
## Install only the interpreter
```Smalltalk
Metacello new
    baseline: 'DebuggableASTInterpreter';
    repository: 'github://carolahp/DebuggableASTInterpreter:ExceptionsDev';
    load.
```

## Install the debugger
```Smalltalk
Metacello new
    baseline: 'DebuggableASTInterpreter';
    repository: 'github://carolahp/DebuggableASTInterpreter:ExceptionsDev';
    load: #Debugger.
```

Execute the following code in a playground with a `doIt` to test the debugger.

```Smalltalk
(DASTSpecDebugger on: (DASTSession debug: 'MyObject new doStuff')) openWithFullView 
```


## Install the overlays experiments for debugging in isolation (Experimental!)
```Smalltalk
Metacello new
    baseline: 'DebuggableASTInterpreter';
    repository: 'github://carolahp/DebuggableASTInterpreter:ExceptionsDev';
    load: #Overlay.
```

# DebuggableASTInterpreter
An AST interpreter that accepts stepping operations

# Installation
## Install only the interpreter
```Smalltalk
Metacello new
    baseline: 'DebuggableASTInterpreter';
    repository: 'github://carolahp/DebuggableASTInterpreter';
    load.
```

## Install the debugger

```Smalltalk
Metacello new
    baseline: 'DebuggableASTInterpreter';
    repository: 'github://carolahp/DebuggableASTInterpreter';
    load: #Debugger.
```

Execute the following code in a playground with a `doIt` to test the debugger.

```Smalltalk
(DASTSpecDebugger on: (DASTSession debug: 'MyObject new doStuff')) openWithFullView 
```


## Install the overlays experiments for debugging in isolation (Experimental!)
That is not yet synchronized with the master branch.
```Smalltalk
Metacello new
    baseline: 'DebuggableASTInterpreter';
    repository: 'github://carolahp/DebuggableASTInterpreter';
    load: #Overlay.
```

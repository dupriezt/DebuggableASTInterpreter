# DebuggableASTInterpreter
An AST interpreter that accepts stepping operations

# NextSteps

- *composed messages (messages with messages as arguments)
- *Precedence of composed message (unary, binary, keyword)
- *assignments
  - *temporary
  - *instance variable
  - *global variable / class variable
- *self 
- *super
- +primitive code evaluation in case the primitive fails
- +Does not understand

- *cascades
- *step into bloques
- *step into metodos
- *step over method
- *step over bloques


Preguntas:
- exceptions: estudiar comportamiento en pharo cuando se hace step. Que deberia pasar cuando se hace step en un signal exception, que hacer con el stack, que nodo seleccionar? etc
- que comportamiento debiera tener el stepping cuando el programa ya retorno

- Ejemplos

 * p := Point new.
 * p x: 1 y:2.



More advanced ones
- *Blocks
- Exceptions
- breakpoints
- non local return (normal and dead context case)


  check strategy design pattern
  

  

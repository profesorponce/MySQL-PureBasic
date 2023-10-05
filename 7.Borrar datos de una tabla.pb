;-----------------------------------------------------------------------
; Borrar datos de un RecordSet en una tabla de una bdd MySQL en PureBasic
; (c) 2023 por Ricardo Ponce
; https://profesorponce.blogspot.com/
;-----------------------------------------------------------------------

; Base de datos
; -------------------------------------------------------
; Nombre = JavaBDD
; Usuario = root (password =no)
; 
; Tabla   = usuarios
; 
;           Nombre      tipo      tamaño  autoincremental
;           ----------  --------  ------  ---------------
; Campo 1 = id          int                    si 
; Campo 2 = Nombre      varchar   50           no 
; Campo 3 = Correo      varchar   30           no
; Campo 4 = Oficina     varchar   20           no
; -------------------------------------------------------

; Para borrar un registro usamos DatabaseUpdate(). En este ejemplo vamos a eliminar 
; la ficha de Laura 
;
; En la acción de eliminar podemos identificar el registro (fila) con un campo
; o una compinación de ellos (esto hace que el borrado sea más seguro) usando
; el operador logico AND
;
; Lo haremos mediante alguna de estas variantes:
; 
; DB_Command$ ="DELETE FROM usuarios WHERE nombre='Laura'" (solo nombre)
;              "DELETE FROM usuarios WHERE id=5" (solo id)
;              "DELETE FROM usuarios WHERE nombre='Laura' and id=10" (con nombre+id)
;
; La orden Select estructurada Así permite obtener el campo id de Laura. 
; Con GetDatabaseString(#DB_Id, 0) donde Columna 0 individualiza el registro de Laura. 
; Tenga en cuenta que pueden haber más de una Laura en la tabla, por lo que debería ver si 
; el bucle de rastreo del RecordSet devuelve o no otro resultado y seleccionar de entre ellos
; cuál registro debe ser modificado.
;
; En PureBasic para generar el ResulSet de MySQL usamos la función DatabaseQuery
; y para modificar un registro se usa DatabaseUpdate
;

  UseMySQLDatabase()

  ; Debe tener el server corriendo en localhost y tener la base de datos ya creada
  #DB_Id = 1
  DB_name$ = "javabdd"
  DB_usuario$="root"
  DB_password$=""
     
  ;-----------------------------------------------------------------------
  ;Establecer una conexion con una base de datos ya creada
  ;-----------------------------------------------------------------------
  If OpenDatabase(#DB_Id, "host=localhost port=3306 dbname="+ DB_name$, DB_usuario$, DB_password$)
    
     MessageRequester("MySQL", "Conectado a MySQL: "+DB_name$)
    
     DB_Command$ ="DELETE FROM usuarios WHERE nombre='Laura'"
     ; este borrado afecta directamente al registro de Laura
     ; asegurese que haya solo una Laura porque la modificación se multiplicará en todos
     ; los registros en los que el nombre sea 'Laura' es por eso que se conseja borrar
     ; usando la seleccion de multiples campos con AND, lo que limita enormemente
     ; las posiblidades de error
          
     If DatabaseUpdate(#DB_Id, DB_Command$) 
        MessageRequester("MySQL", "Se borro el registro (fila) solicitada")
     Else 
        MessageRequester("MySQL", "Falla en el borrado: "+DatabaseError())
     EndIf       
   
  Else
    MessageRequester("MySQL", "Falla en la conexión: "+DatabaseError())
  EndIf
    
  CloseDatabase (#DB_Id)
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 76
; FirstLine = 47
; EnableXP
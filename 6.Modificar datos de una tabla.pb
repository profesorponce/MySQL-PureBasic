;-----------------------------------------------------------------------
; Modificar datos de un RecordSet en una tabla de una bdd MySQL en PureBasic
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

; Para actualizar un registro usamos DatabaseUpdate(). En este ejemplo vamos a cambiar 
; el correo electrónico de Laura 
;
; En la tabla hemos definido un campo id (que es indice), es por eso que primero vamos
; a obtener el id de Laura para luego usarlo en el UPDATE y modificar su correo electrónico
;
; Lo haremos mediante:
; 
; DB_Command$ ="SELECT id FROM usuarios WHERE nombre='Laura'" 
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
    
     DB_Command$ ="UPDATE usuarios SET correo='laura@hotmail.com' WHERE nombre='Laura'"
     ; esta consulta permite generar en MySQL el RecordSet en este caso en particular lo ideal es que 
     ; la consulta DEVUELVA UN SOLO RESULTADO para hacer una  modificación especifica, es decir que 
     ; el RecordSet resultante sea de 1 sola ficha dentro de la tabla consultada    
     ; asegurese que haya solo una Laura porque la modificación se multiplicará en todos
     ; los registros en los que el nombre sea 'Laura'
          
     If DatabaseUpdate(#DB_Id, DB_Command$) 
        MessageRequester("MySQL", "Se actualizó la información del registro")
     Else 
        MessageRequester("MySQL", "Falla en la actualización: "+DatabaseError())
     EndIf       
   
  Else
    MessageRequester("MySQL", "Falla en la conexión: "+DatabaseError())
  EndIf
    
  CloseDatabase (#DB_Id)
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 67
; FirstLine = 43
; EnableXP
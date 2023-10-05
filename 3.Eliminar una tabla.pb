;-----------------------------------------------------------------------
; Eliminar una tabla en una base de datos MySQL en PureBasic
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

; Usaremos DatabaseUpdate() para sentencias SQL que impliquen 
; modificaciones en la base de datos como INSERT, UPDATE, 
; DELETE, DROP etc. 
;
; DROP TABLE nombre_de_tabla elimina una tabla completa con todo su contenido

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
    
     ;crear una tabla dentro de la base de datos
     DB_TableName$="usuarios"
     DB_Command$ ="drop table "+DB_TableName$
     
     If DatabaseUpdate(#DB_Id, DB_Command$)
        MessageRequester("MySQL", "Table eliminada")  
     Else   
        MessageRequester("MySQL", "Tabla no existe en la base de datos")  
     EndIf
     
  Else
    MessageRequester("MySQL", "Falla en la conexión: "+DatabaseError())
  EndIf
    
  CloseDatabase (#DB_Id)
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 18
; FirstLine = 8
; EnableXP
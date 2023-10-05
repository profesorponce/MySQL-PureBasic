;-----------------------------------------------------------------------
; Consultar datos de un RecordSet en una tabla de una bdd MySQL en PureBasic
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

; Las consultas de datos se hacen con métodos internos de MySQL que devuelven un ResultSet
; El ResultSet es una conexión activa hacia los datos que nos permite recibirlos a medida que los pidamos
; Es por eso que si una consulta devuelve muchos resultados, no se nos va a agotar la memoria
; Para traer el primer resultado, debemos llamar el método Next() del ResulSet. 
; Para el siguiente dato usamos otro Next() y Así sucesivamente hasta que Next() devuelva un resultado false
; indicando que llegamos al final de la consulta
;
; En PureBasic para generar el ResulSet de MySQL usamos la función DatabaseQuery
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
    
     DB_Command$ ="SELECT * FROM usuarios" ; esta consulta permite generar en MySQL el RecordSet
     
     ;otro tipo de consulta puede ser-> "SELECT * FROM employee WHERE id=?"    
     
     If DatabaseQuery(#DB_Id,  DB_Command$) ; Genera el RecordSet de la tabla 'usuarios'
  
        ; En nuestra base de datos, latabla 'usuarios"
        ; esta estructurada de este modo:
        ; 
        ; Columna 0 = id
        ; Columna 1 = Nombre
        ; Columna 2 = Correo 
        ; Columna 3 = Oficina
       
        DB_Columna = 0 ;se programa para ver la columna 'nombre'
       
        While NextDatabaseRow(#DB_Id)                  ; genera un bucle que se repetirá desde el primer
           Debug GetDatabaseString(#DB_Id, DB_Columna) ; al último elemento del RecordSet
        Wend                                           ; y lo presenta en la ventana DEBUG de PureBasic
    
        FinishDatabaseQuery(#DB_Id) ; fin de la consulta
        
     EndIf

  Else
    MessageRequester("MySQL", "Falla en la conexión: "+DatabaseError())
  EndIf
    
  CloseDatabase (#DB_Id)
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 50
; FirstLine = 27
; EnableXP
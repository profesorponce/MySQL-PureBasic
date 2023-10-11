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
    
     ; Nombre   Email              Trabaja en
     ; -------  -----------------  --------------
     ; Juan     juan@gmail.com     administracion
     ; Pedro    pedro@yahoo.com    ventas
     ; Antonio  antonio@live.com   expediciones
     ; Laura    laura@hotmail.com  despacho
        
     ; Queremos ver los empleados que trabajan en la oficina DESPACHO'
     DB_Command$ ="SELECT * FROM usuarios WHERE oficina ='despacho'"
     
     If DatabaseQuery(#DB_Id,  DB_Command$) ; Genera el RecordSet de la tabla 'usuarios'
  
        ; En nuestra base de datos, latabla 'usuarios"
        ; esta estructurada de este modo:
        ; 
        ; Columna 0 = id
        ; Columna 1 = Nombre
        ; Columna 2 = Correo 
        ; Columna 3 = Oficina
       
        DB_Consulta_id = 0     ;ver los campos ID        |
        DB_Consulta_nombre = 1 ;ver los campos NOMBRE    | Estas variables definen los
        DB_Consulta_correo = 2 ;ver los campos CORREO    | datos que se sean ver
        DB_Consulta_correo = 3 ;ver los campos OFICINA   |
       
       
        While NextDatabaseRow(#DB_Id)                          ; genera un bucle que se repetirá desde el primer
          Debug GetDatabaseString(#DB_Id, DB_Consulta_nombre)  ; al último elemento del RecordSet mostrando los 
        Wend                                                   ; nombres de los empleados  que trabajan en DESPACHO
    
        FinishDatabaseQuery(#DB_Id) ; fin de la consulta
        
     EndIf

  Else
    MessageRequester("MySQL", "Falla en la conexión: "+DatabaseError())
  EndIf
    
  CloseDatabase (#DB_Id)
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 54
; FirstLine = 57
; EnableXP
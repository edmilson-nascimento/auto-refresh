*&---------------------------------------------------------------------*
*& Report YTESTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yteste.



INITIALIZATION .

*  DATA(lv_date)  = CONV sy-datum( '20200101' ) .
*  DATA(lv_attyp) = CONV mara-attyp( '02' ) .
*
*  SELECT matnr
*   up to 999 rows
*    FROM mara
*    INTO TABLE @DATA(lt_mara)
*   WHERE ersda GT @lv_date
*     AND attyp EQ @lv_attyp .
*
*  LOOP AT lt_mara INTO DATA(ls_mara) .
*
*    DATA(ls_header) =
**     VALUE zdt_item_confirmation_article1( matnr = ls_mara-matnr ) .
*      VALUE zdt_item_confirmation_article1( matnr = |{ ls_mara-matnr alpha = in }| ) .
*
*
*    DATA(lt_item) =
*      VALUE zdt_item_confirmation_arti_tab( ( meinh      = 'UN'
*                                              brgew      = 1
*                                              ntgew      = 1
*                                              gewei      = 'KG'
*                                              laeng      = 1
*                                              breit      = 1
*                                              hoehe      = 1
*                                              meabm      = 'CM'
*                                              volum      = 1
*                                              voleh      = 'HL' ) ) .
*
*    DATA(ls_request) =
*      VALUE zdt_item_confirmation(
*        article_head_request = ls_header
*        article_item_request = lt_item ) .
*
*    DATA(ls_input) =
*      VALUE zmt_item_confirmation_request(
*        mt_item_confirmation_request = ls_request ) .
*
*    zclca_jda=>item_confirmation( is_input = ls_input ).
*
*  ENDLOOP .


  CLASS lcl_receiver DEFINITION DEFERRED  .


  DATA:
    test     TYPE i,
    receiver TYPE REF TO lcl_receiver,
    timer    TYPE REF TO cl_gui_timer,
    interval TYPE i VALUE 5,
    counter  TYPE i.



*class lcl_receiver definition.
*  public section.
*    methods:
*      handle_finished for event finished of cl_gui_timer.
*endclass.

*class lcl_receiver implementation.
*method handle_finished.
*
*  add INTERVAL to counter.
*  message s002 with counter.
*  call method timer->run.
*endmethod.
*endclass.


CLASS lcl_receiver DEFINITION.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_out,
        uname TYPE sy-uname,
        uzeit TYPE sy-uzeit,
      END OF ty_out,
      tab_out TYPE TABLE OF ty_out.


    METHODS handle_finished
        FOR EVENT finished OF cl_gui_timer .

    METHODS show_data .

  PRIVATE SECTION .

    DATA:
      gt_out TYPE tab_out .

    METHODS refresh_data .

ENDCLASS.



CLASS lcl_receiver IMPLEMENTATION.

  METHOD handle_finished.

    ADD interval TO counter.
*    MESSAGE s000(>0) WITH sy-uzeit .

    me->refresh_data( ) .
    CALL METHOD timer->run.

  ENDMETHOD.


  METHOD show_data .

    DATA:
      lo_salv_table TYPE REF TO cl_salv_table,
      lo_display    TYPE REF TO cl_salv_display_settings.


    " Primeira chamada do method
    IF ( lines( me->gt_out ) EQ 0 ) .
      me->refresh_data( ) .
    ENDIF .

    cl_salv_table=>factory( IMPORTING r_salv_table = lo_salv_table
                            CHANGING  t_table      = me->gt_out ) .

    lo_salv_table->display( ) .

  ENDMETHOD .


  METHOD refresh_data .

    me->gt_out = VALUE #( ( uname = sy-uname
                            uzeit = sy-uzeit ) ) .

  ENDMETHOD .

ENDCLASS.


START-OF-SELECTION .

  CREATE OBJECT timer.
  CREATE OBJECT receiver.
  SET HANDLER receiver->handle_finished FOR timer.
  timer->interval = interval.
  CALL METHOD timer->run.
*  WRITE 'Wait for timer messages...'.
  receiver->show_data( ) .

  CALL METHOD timer->run.



*  " Criando objetos
*  CREATE OBJECT timer.
*  CREATE OBJECT receiver.
*
*  " Informando qual metodo sera chamado quando o timer for executado
*  SET HANDLER receiver->handle_finished FOR timer.
*
*  " Passando o atributo de tempo
*  timer->interval = interval .
*  " Executando atualizacao
*  CALL METHOD timer->run.
*
**  WRITE 'Wait for timer messages...'.
*
*  CALL METHOD timer->run.

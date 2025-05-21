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
    interval TYPE i VALUE 3,
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
      go_salv_table TYPE REF TO cl_salv_table,
      gt_out        TYPE tab_out.

    METHODS get_data .

ENDCLASS.



CLASS lcl_receiver IMPLEMENTATION.

  METHOD handle_finished.

    ADD interval TO counter.
*    MESSAGE s000(>0) WITH sy-uzeit .

    me->get_data( ) .
    CALL METHOD timer->run.

  ENDMETHOD.


  METHOD show_data .

    " Primeira chamada do method
    IF ( lines( me->gt_out ) EQ 0 ) .
      me->get_data( ) .
    ENDIF .

    cl_salv_table=>factory( IMPORTING r_salv_table = me->go_salv_table
                            CHANGING  t_table      = me->gt_out ) .

    me->go_salv_table->display( ) .


  ENDMETHOD .


  METHOD get_data .

    me->gt_out = VALUE #( ( uname = sy-uname
                            uzeit = sy-uzeit ) ) .

    IF ( me->go_salv_table IS BOUND ) .

      me->go_salv_table->refresh(
*      EXPORTING
*        s_stable     = s_stable
refresh_mode = if_salv_c_refresh=>soft
) .

    ENDIF .


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




*
*  CLASS lcl_receiver DEFINITION DEFERRED  .
*
*
*  DATA:
*    test     TYPE i,
*    receiver TYPE REF TO lcl_receiver,
*    timer    TYPE REF TO cl_gui_timer,
*    interval TYPE i VALUE 3,
*    counter  TYPE i.
*
*
*
**class lcl_receiver definition.
**  public section.
**    methods:
**      handle_finished for event finished of cl_gui_timer.
**endclass.
*
**class lcl_receiver implementation.
**method handle_finished.
**
**  add INTERVAL to counter.
**  message s002 with counter.
**  call method timer->run.
**endmethod.
**endclass.
*
*
*CLASS lcl_receiver DEFINITION.
*
*  PUBLIC SECTION.
*
*    TYPES:
*      BEGIN OF ty_out,
*        uname TYPE sy-uname,
*        uzeit TYPE sy-uzeit,
*      END OF ty_out,
*      tab_out TYPE TABLE OF ty_out.
*
*
*    METHODS handle_finished
*        FOR EVENT finished OF cl_gui_timer .
*
*    METHODS show_data
*      RAISING
*        cx_salv_msg .
*
*  PRIVATE SECTION .
*
*    DATA:
*      go_salv_table TYPE REF TO cl_salv_table,
*      gt_out        TYPE tab_out.
*
*    METHODS get_data .
*
*ENDCLASS.
*
*
*
*CLASS lcl_receiver IMPLEMENTATION.
*
*  METHOD handle_finished.
*
*    ADD interval TO counter.
*
*    me->get_data( ) .
*
*    CALL METHOD timer->run .
*
*  ENDMETHOD.
*
*
*  METHOD show_data .
*
*    " Primeira chamada do method
*    IF ( lines( me->gt_out ) EQ 0 ) .
*      me->get_data( ) .
*    ENDIF .
*
*    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
**      EXPORTING
**        i_interface_check           = space
**        i_bypassing_buffer          = space
**        i_buffer_active             = space
**        i_callback_program          = space
**        i_callback_pf_status_set    = space
**        i_callback_user_command     = space
**        i_callback_top_of_page      = space
**        i_callback_html_top_of_page = space
**        i_callback_html_end_of_list = space
**        i_structure_name            = i_structure_name
**        i_background_id             = i_background_id
**        i_grid_title                = i_grid_title
**        i_grid_settings             = i_grid_settings
**        is_layout                   = is_layout
**        it_fieldcat                 = it_fieldcat
**        it_excluding                = it_excluding
**        it_special_groups           = it_special_groups
**        it_sort                     = it_sort
**        it_filter                   = it_filter
**        is_sel_hide                 = is_sel_hide
**        i_default                   = 'X'
**        i_save                      = space
**        is_variant                  = is_variant
**        it_events                   = it_events
**        it_event_exit               = it_event_exit
**        is_print                    = is_print
**        is_reprep_id                = is_reprep_id
**        i_screen_start_column       = 0
**        i_screen_start_line         = 0
**        i_screen_end_column         = 0
**        i_screen_end_line           = 0
**        i_html_height_top           = 0
**        i_html_height_end           = 0
**        it_alv_graphics             = it_alv_graphics
**        it_hyperlink                = it_hyperlink
**        it_add_fieldcat             = it_add_fieldcat
**        it_except_qinfo             = it_except_qinfo
**        ir_salv_fullscreen_adapter  = ir_salv_fullscreen_adapter
**        o_previous_sral_handler     = o_previous_sral_handler
**      IMPORTING
**        e_exit_caused_by_caller     = e_exit_caused_by_caller
**        es_exit_caused_by_user      = es_exit_caused_by_user
*      TABLES
*        t_outtab      = me->gt_out
*      EXCEPTIONS
*        program_error = 1
*        OTHERS        = 2.
*    IF sy-subrc <> 0.
**     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*
**    TRY .
**        cl_salv_table=>factory( IMPORTING r_salv_table = me->go_salv_table
**                                CHANGING  t_table      = me->gt_out ) .
**
**        me->go_salv_table->display( ) .
**
**      CATCH cx_salv_msg .
**
**    ENDTRY .
*
*
*  ENDMETHOD .
*
*
*  METHOD get_data .
*
*    me->gt_out = VALUE #( ( uname = sy-uname
*                            uzeit = sy-uzeit ) ) .
*
*    IF ( me->go_salv_table IS BOUND ) .
*
**      me->go_salv_table->set_data( CHANGING t_table = me->gt_out ) .
**      CATCH cx_salv_no_new_data_allowed.
*      me->go_salv_table->refresh( refresh_mode = if_salv_c_refresh=>full ).
**        EXPORTING
***         s_stable     = s_stable
**          refresh_mode = if_salv_c_refresh=>soft ) .
*
*
**go_joblist_alv->refresh( ).
*      cl_gui_cfw=>flush( ).  " I event tried to do a flush - without effect
*
*    ENDIF .
*
*
*  ENDMETHOD .
*
*ENDCLASS.
*
*
*START-OF-SELECTION .
*
*  CREATE OBJECT timer.
*  CREATE OBJECT receiver.
*  SET HANDLER receiver->handle_finished FOR timer.
*  timer->interval = interval.
*  CALL METHOD timer->run.
**  WRITE 'Wait for timer messages...'.
*  receiver->show_data( ) .
*
*  CALL METHOD timer->run.
*
*
*
**  " Criando objetos
**  CREATE OBJECT timer.
**  CREATE OBJECT receiver.
**
**  " Informando qual metodo sera chamado quando o timer for executado
**  SET HANDLER receiver->handle_finished FOR timer.
**
**  " Passando o atributo de tempo
**  timer->interval = interval .
**  " Executando atualizacao
**  CALL METHOD timer->run.
**
***  WRITE 'Wait for timer messages...'.
**
**  CALL METHOD timer->run.

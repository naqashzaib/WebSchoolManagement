<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="add_classes.aspx.cs" Inherits="suitespk.School.add_classes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Student Data</title>
      <script>
          $(document).ready(function () {
              //html styles
              $('button').css('border-radius', '0px');
              $('input').css('border-radius', '0px');
              $('.modal-content').css('border-radius', '0px');
              $(document).on('click', '#btnAddstd', function () {
                  $('#txtstdname').val("");
                  $('#txtstdfather').val("")
                  $('#txtstdclass').val("")
                  $('#txtstdphone').val("")
                  $('#btnaddstd').show();
                  $('#btnupdaterec').hide();
                  $('#insertHead').show();
                  $('#updateHead').hide();

              });
              showStdInfo();

              //Insert Class Name Script
              $('#btnaddstd').on('click', function () {
                  var btn = $(this);
                  btn.prop('disabled', true);
                  setTimeout(function () {
                      btn.prop('disabled', false);
                  }, 1000);
                  if ($('#txtstdname').val() == "") {
                      toastr["error"]("Class name is required");
                      $('#txtstdname').focus().css('border-color', '#d9534f');
                      return false;
                  }
                
                  var addstudent = {};
                  addstudent.std_name = $('#txtstdname').val();
                  $.ajax({
                      async: false,
                      url: '../webservices/Svr_Add_Student.asmx/Addclasses',
                      method: 'POST',
                      contentType: 'application/json;charset=utf-8',
                      data: '{ObjAddStd:' + JSON.stringify(addstudent) + '}',
                      success: function (data) {
                          if (data[0].Dataexist == "Not Found") {
                              swal({
                                  title: "Done",
                                  text: "Class info succefully saved.",
                                  icon: "success",
                              });
                              // toastr["success"]("Class Name succefully saved.");
                              showStdInfo();
                              $('#myModal').modal('toggle');
                          }
                          else {
                              /*swal({
                                  title: "Sorry",
                                  text: "Bank Name Already Exist",
                                  icon: "warning",
                              });*/
                              $toastr["warning"]("Class Name Already Exist");
                              $('#txtstdname').focus().css('border-color', '#ff7043');

                          }

                      },
                      error: function (jqXHR, exception) {
                          if (jqXHR.status == 500) {
                              toastr["error"]("Internal server error <b>[500]</b> occured");
                          }
                      }
                  });
              });

              //Get data in pop-up
              var StdInfoId;
              $(document).on('click', '.editStdInfo', function () {
                  $('#btnaddstd').hide();
                  $('#btnupdaterec').show();
                  $('#insertHead').hide();
                  $('#updateHead').show();
                  StdInfoId = ($(this).attr("id"));
                  var $tr = $(this).closest('tr');
                  $('#txtstdname').val($tr.find('td:nth-child(2)').text());
              });


              //Update Class Name
              $(document).on('click', '#btnupdaterec', function () {
                  if ($('#txtstdname').val() == "") {
                      toastr["error"]("Don't leave empty <b>Class Name</b> field");
                      $('#txtstdname').focus().css('border-color', '#d9534f');
                      return false;
                  }
                  var addstudent = {};
                  addstudent.std_id = StdInfoId;
                  addstudent.std_name = $('#txtstdname').val();
                  $.ajax({
                      async: false,
                      url: '../webservices/Svr_Add_Student.asmx/UpdateClasses',
                      method: 'POST',
                      contentType: 'application/json;charset=utf-8',
                      data: '{ObjEditStdInfo:' + JSON.stringify(addstudent) + '}',
                      success: function (data) {
                          if (data[0].Dataexist == "Not Found") {
                              swal({
                                  title: "Done",
                                  text: "Class info succefully Update.",
                                  icon: "success",
                              });
                              // toastr["success"]("Class Name succefully saved.");
                              showStdInfo();
                              $('#myModal').modal('toggle');
                          }
                          else {
                              swal({
                                  title: "info",
                                  text: "Class Name Already Exist",
                                  icon: "info",
                              });
                        

                          }
                      },
                      error: function (jqXHR, exception) {
                          if (jqXHR.status == 500) {
                              toastr["error"]("Internal server error <b>[500]</b> occured");
                          }
                      }
                  });
              });

              //Delete Class Name
              $(document).on('click', '.delstdinfo', function () {
                  var StdInfoId = ($(this).attr("id"));
                  var addstudent = {};
                  addstudent.std_id = StdInfoId;
                  if (confirm("Are you really want to delete this Class Name?") == true) {
                      $.ajax({
                          async: false,
                          url: '../webservices/Svr_Add_Student.asmx/DelClasses',
                          method: 'POST',
                          contentType: 'application/json;charset=utf-8',
                          data: '{ObjDelStdInfo:' + JSON.stringify(addstudent) + '}',
                          dataType: 'JSON',
                          success: function (data) {
                              swal({
                                  title: "Done!",
                                  text: "Class Name successfully deleted.",
                                  icon: "success",
                              });
                              // toastr["success"]("Class Name successfully deleted.");
                              showStdInfo();
                          },
                          error: function (jqXHR, exception) {
                              if (jqXHR.status == 500) {
                                  toastr["error"]("Internal server error <b>[500]</b> occured");
                              }
                          }
                      });
                      return true;
                  }
                  else {
                      swal({
                          text: "Class Name is saved.",
                          icon: "error",
                      });
                      return false;
                  }
              });
          });

          //showing Class Name in table
          function showStdInfo() {
              $.ajax({
                  url: '../webservices/Svr_Add_Student.asmx/Getclasses',
                  async: false,
                  method: 'POST',
                  dataType: 'json',
                  success: function (data) {
                      var voucherOptions = $('#rowstudents');
                      voucherOptions.empty();
                      $(data).each(function (index, infostd) {
                          voucherOptions.append('<tr><td>' + (index + 1) + '</td> <td>' + infostd.std_name + '</td> <td><button type="button" class="btn btn-info editStdInfo" data-toggle="modal" data-target="#myModal" style="border-radius:0px;"  id="' + infostd.std_id + '"><i class="icon-pencil"></i></button>&nbsp;&nbsp;&nbsp;<button type="button" class="btn btn-danger delstdinfo" style="border-radius:0px;" id="' + infostd.std_id + '" ><i class="icon-trash"></i></button></td> </tr>');
                      });
                  },
                  error: function (jqXHR, exception) {
                      if (jqXHR.status == 500) {
                          msg = 'Internal Server Error [500].';
                          swal({
                              type: 'error',
                              title: 'Oops...',
                              text: msg,
                              showConfirmButton: false,
                              timer: 2000
                          });
                      }
                  }
              });
          }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  
    <!-- Begin page -->
    <div id="wrapper">
        <div class="content-page">
            <div class="content">

                <!-- Start Content-->
                <div class="container-fluid">

                    <!-- start page title -->
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <h4 class="page-title">All Class Records</h4>
                                <div class="clearfix"></div>
                            </div>
                        </div>
                    </div>
                    <!-- end page title -->
                    <hr />
                    <button type="button" class="btn btn-danger" id="btnAddstd" data-toggle="modal" data-target="#myModal">Add New Class</button>
                        <div class="row">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-body table-responsive">
                                        <table id="datatable" class="table table-bordered dt-responsive nowrap" style="border-collapse: collapse; border-spacing: 0; width: 100%;">

                                            <thead>
                                            <th style="width: 6%;">Sr#</th>
                                            <th>Class Name</th>
                                            <th>Edit/Delete</th>
                                            </thead>
                                            <tbody id="rowstudents">
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
       
                </div>


            </div>


        </div>
            <div id="myModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" style="display: none;" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="insertHead"><strong>Add Class Name</strong></h4>
                    <h4 class="modal-title" id="updateHead"><strong>Edit Class Name</strong></h4>
                    <!--<button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">×</button>-->
                </div>
                <div class="modal-body">
                    <form class="" action="#" autocomplete="off" method="post">
                        <div class="form-group">
                            <label for="txtstdname">Class Name<span class="text-danger">*</span></label>
                            <input id="txtstdname" type="text" name="txtstdname" placeholder="Enter student name" class="form-control" />
                        </div>
                     
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary waves-effect" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary" id="btnaddstd">Save</button>
                    <button type="button" class="btn btn-info" id="btnupdaterec">Done Edit</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    </div>
    <!-- sample modal content -->

    <!-- /.modal -->
    <!-- END wrapper -->
</asp:Content>

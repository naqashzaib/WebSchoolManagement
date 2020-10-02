<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="Add_Teacher.aspx.cs" Inherits="suitespk.School.Add_Teacher" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Teacher Data</title>
      <script>
          $(document).ready(function () {
              //html styles
              $('button').css('border-radius', '0px');
              $('input').css('border-radius', '0px');
              $('.modal-content').css('border-radius', '0px');
              $(document).on('click', '#btnAddstd', function () {
                  $('#btnaddstd').show();
                  $('#btnupdaterec').hide();
                  $('#insertHead').show();
                  $('#updateHead').hide();
                  clearallbox();
              
              });
              showStdInfo();

              //Insert Teacher Info Script




              $('#btnaddstd').on('click', function () {
                  var btn = $(this);
                  btn.prop('disabled', true);
                  setTimeout(function () {
                      btn.prop('disabled', false);
                  }, 1000);
                  if ($('#txtstdname').val() == "") {
                      toastr["error"]("Teacher name is required");
                      $('#txtstdname').focus();
                      return false;
                  }
                  if ($('#txtlastname').val() == "") {
                      toastr["error"]("Last Name is required");
                      $('#txtlastname').focus();
                      return false;
                  }


                  if ($('#txtfathername').val() == "") {
                      toastr["error"]("Father Name is required");
                      $('#txtfathername').focus();
                      return false;
                  }
                  if ($('input[name="gender"]:checked').length == 0) {
                      toastr["error"]("Please Select Gender");
                      return false;
                  }

                
                  if ($('#txtstdphone').val() == "") {
                      toastr["error"]("Phone number is required");
                      $('#txtstdphone').focus();
                      return false;
                  }
                  if ($('#txtemail').val() == "") {
                      toastr["error"]("E-mail is required");
                      $('#txtemail').focus();
                      return false;
                  }
                  if (!isEmail($('#txtemail').val())) {

                      toastr["error"]("Please Enter E-mail Formate Correct");
                      $('#txtemail').focus();
                      return false;
                  }



                
                  if ($('#txtpassword').val() == "") {
                      toastr["error"]("Password is required");
                      $('#txtpassword').focus();
                      return false;
                  }


                  var addTeacher = {};
                  addTeacher.std_name = $('#txtstdname').val();
                  addTeacher.std_lastname = $('#txtlastname').val();
                  addTeacher.std_father = $('#txtfathername').val();
                  addTeacher.std_gender = $('input[name=gender]:checked').val();
                  addTeacher.std_class = $('#txtClassName').val();
                  addTeacher.std_phone_no = $('#txtstdphone').val();
                  addTeacher.std_email = $('#txtemail').val();
                  addTeacher.std_password = $('#txtpassword').val();
                  $.ajax({
                      async: false,
                      url: '../webservices/Svr_Add_Student.asmx/fnAddTecher',
                      method: 'POST',
                      contentType: 'application/json;charset=utf-8',
                      data: '{ObjAddStd:' + JSON.stringify(addTeacher) + '}',
                      success: function (data) {
                          if (data[0].Dataexist == "Not Found") {
                              swal({
                                  title: "Done",
                                  text: "Teacher info succefully saved.",
                                  icon: "success",
                              });
                              // toastr["success"]("Teacher info succefully saved.");
                              showStdInfo();
                              $('#myModal').modal('toggle');
                          }
                          else if (data[0].Dataexist == "found_email") {
                              swal({
                                  title: "info",
                                  text: "Teacher E-mail Alread Exist",
                                  icon: "success",
                              });
                          }
                          else {
                              swal({
                                  title: "Info",
                                  text: "Teacher Info Alread Exist",
                                  icon: "info",
                              });
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
                  $('#txtlastname').val($tr.find('td:nth-child(3)').text());
                  $('#txtfathername').val($tr.find('td:nth-child(4)').text());

                  var getgendervalue = $tr.find('td:nth-child(5)').text();
                  
                  if (getgendervalue == "") {
                      $('input[name="gender"]').prop('checked', false);

                  } else {
                      $("input:radio[value='" + getgendervalue + "']").prop('checked', true);

                  }

                  $('#txtstdphone').val($tr.find('td:nth-child(6)').text());
                  $('#txtemail').val($tr.find('td:nth-child(7)').text());
                  $('#txtpassword').val($tr.find('td:nth-child(8)').text());
                
              });

              //Update Teacher info
              $(document).on('click', '#btnupdaterec', function () {
                  var btn = $(this);
                  btn.prop('disabled', true);
                  setTimeout(function () {
                      btn.prop('disabled', false);
                  }, 1000);
                  if ($('#txtstdname').val() == "") {
                      toastr["error"]("Teacher name is required");
                      $('#txtstdname').focus();
                      return false;
                  }
                  if ($('#txtlastname').val() == "") {
                      toastr["error"]("Last Name is required");
                      $('#txtlastname').focus();
                      return false;
                  }
                  if ($('#txtfathername').val() == "") {
                      toastr["error"]("Father Name is required");
                      $('#txtfathername').focus();
                      return false;
                  }
                  if ($('input[name="gender"]:checked').length == 0) {
                      toastr["error"]("Please Select Gender");
                      return false;
                  }

               
                  if ($('#txtstdphone').val() == "") {
                      toastr["error"]("Phone number is required");
                      $('#txtstdphone').focus();
                      return false;
                  }
                  if ($('#txtemail').val() == "") {
                      toastr["error"]("E-mail is required");
                      $('#txtemail').focus();
                      return false;
                  }
                  if (!isEmail($('#txtemail').val())) {

                      toastr["error"]("Please Enter E-mail Formate Correct");
                      $('#txtemail').focus();
                      return false;
                  }



                  if ($('#txtpassword').val() == "") {
                      toastr["error"]("Password is required");
                      $('#txtpassword').focus();
                      return false;
                  }

                  var addTeacher = {};
                  addTeacher.std_name = $('#txtstdname').val();
                  addTeacher.std_lastname = $('#txtlastname').val();
                  addTeacher.std_father = $('#txtfathername').val();
                  addTeacher.std_gender = $('input[name=gender]:checked').val();
                  addTeacher.std_class = $('#txtClassName').val();
                  addTeacher.std_phone_no = $('#txtstdphone').val();
                  addTeacher.std_email = $('#txtemail').val();
                  addTeacher.std_password = $('#txtpassword').val();
                  addTeacher.std_id = StdInfoId;
                  $.ajax({
                      async: false,
                      url: '../webservices/Svr_Add_Student.asmx/EditTecherInfo',
                      method: 'POST',
                      contentType: 'application/json;charset=utf-8',
                      data: '{ObjEditStdInfo:' + JSON.stringify(addTeacher) + '}',
                      success: function (data) {
                          swal({
                              title: "Done",
                              text: "Teacher info succefully saved.",
                              icon: "success",
                          });
                          // toastr["success"]("Teacher info succefully saved.");
                          showStdInfo();
                          $('#myModal').modal('toggle');

                      },
                      error: function (jqXHR, exception) {
                          if (jqXHR.status == 500) {
                              toastr["error"]("Internal server error <b>[500]</b> occured");
                          }
                      }
                  });
              });
              //Delete Teacher info
              $(document).on('click', '.delstdinfo', function () {
                  var StdInfoId = ($(this).attr("id"));
                  var addTeacher = {};
                  addTeacher.std_id = StdInfoId;
                  if (confirm("Are you really want to delete this Teacher info?") == true) {
                      $.ajax({
                          async: false,
                          url: '../webservices/Svr_Add_Student.asmx/DelTecherInfo',
                          method: 'POST',
                          contentType: 'application/json;charset=utf-8',
                          data: '{ObjDelStdInfo:' + JSON.stringify(addTeacher) + '}',
                          dataType: 'JSON',
                          success: function (data) {
                              swal({
                                  title: "Done!",
                                  text: "Teacher info successfully deleted.",
                                  icon: "success",
                              });
                              // toastr["success"]("Teacher info successfully deleted.");
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
                          text: "Teacher info is saved.",
                          icon: "error",
                      });
                      return false;
                  }
              });
          });


          function clearallbox() {
              $('#txtstdname').val("");
              $('#txtlastname').val("");
              $('#txtfathername').val("");

              $('input[name="gender"]').prop('checked', false);

              $('#txtClassName').val("-1");
              $('#txtstdphone').val("");
              $('#txtemail').val("");
              $('#txtpassword').val("");
          }


          //showing Teacher info in table
          function showStdInfo() {
              $.ajax({
                  url: '../webservices/Svr_Add_Student.asmx/GetTecherInfo',
                  async: false,
                  method: 'POST',
                  dataType: 'json',
                  success: function (data) {
                      var voucherOptions = $('#rowTeachers');
                      voucherOptions.empty();
                      $(data).each(function (index, infostd) {
                          voucherOptions.append('<tr><td>' + (index + 1) + '</td> <td>' + infostd.std_name + '</td><td>' + infostd.std_lastname + '</td>  <td>' + infostd.std_father + '</td><td>' + infostd.std_gender + '</td><td>' + infostd.std_phone_no + '</td><td>' + infostd.std_email + '</td><td>*****</td> <td><button type="button" class="btn btn-info editStdInfo" data-toggle="modal" data-target="#myModal" style="border-radius:0px;"  id="' + infostd.std_id + '"><i class="icon-pencil"></i></button>&nbsp;&nbsp;&nbsp;<button type="button" class="btn btn-danger delstdinfo" style="border-radius:0px;" id="' + infostd.std_id + '" ><i class="icon-trash"></i></button></td> </tr>');
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
          function isEmail(email) {
              var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
              return regex.test(email);
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
                                <h4 class="page-title">All Teacher Records</h4>
                            </div>
                        </div>
                    </div>
                    <!-- end page title -->
                    <hr />
                    <button type="button" class="btn btn-danger" id="btnAddstd" data-toggle="modal" data-target="#myModal">Add New Teacher</button>
                        <div class="row">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-body table-responsive">
                                        <table id="" class="table table-bordered dt-responsive nowrap" style="border-collapse: collapse; border-spacing: 0; width: 100%;">

                                            <thead>
                                            <th style="width: 6%;">Sr#</th>
                                            <th>Name</th>
                                            <th>Last Name</th>
                                            <th>Father Name</th>
                                            <th>Gender</th>
                                            <th>Phone No</th>
                                            <th>E-mail</th>
                                            <th>Password</th>
                                            <th>Edit/Delete</th>
                                            </thead>
                                            <tbody id="rowTeachers">
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
                    <h4 class="modal-title" id="insertHead"><strong>Add Teacher Info</strong></h4>
                    <h4 class="modal-title" id="updateHead"><strong>Edit Teacher Info</strong></h4>
                    <!--<button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">×</button>-->
                </div>
                <div class="modal-body">
                    <form class="" action="#" autocomplete="off" method="post">
                        <div class="form-group">
                            <label for="txtstdname">Teacher Name<span class="text-danger">*</span></label>
                            <input id="txtstdname" type="text" name="txtstdname" placeholder="Enter Teacher name" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="fname">Last Name</label>
                            <input id="txtlastname" type="text" name="txtlastname" placeholder="Enter Last Name" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="fname">Father Name<span class="text-danger">*</span></label>
                            <input id="txtfathername" type="text" name="txtfathername" placeholder="Enter Father Name" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="fname">Gender </label>
                            <input type="radio" name="gender" value="male"> Male
                            <input type="radio" name="gender" value="female"> Female
                            <input type="radio" name="gender" value="other"> Other                        </div>
                        <div class="form-group">
                            <label for="phone">Phone No.<span class="text-danger">*</span></label>
                            <input id="txtstdphone" type="text" name="txtstdphone" placeholder="Enter phone no." class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="fname">E-mail<span class="text-danger">*</span></label>
                            <input id="txtemail" type="text" name="txtemail" placeholder="Enter E-mail" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="fname">Password<span class="text-danger">*</span></label>
                            <input id="txtpassword" type="password" name="txtpassword" placeholder="Enter Password" class="form-control" />
                        </div>
                        

                        <hr />
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

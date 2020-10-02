<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="suitespk.Profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Profile</title>
    <script src="PasswordCheck/password.js"></script>
    <link href="PasswordCheck/password.css" rel="stylesheet" />
    <script>
        var getimgpath, getimgpath2, oldimg, getcityname;
        $(document).ready(function () {



            $("#txtconpassword").keyup(function () {
                if ($(".txtpassword").val() != $("#txtconpassword").val()) {
                    $("#label-msg").html("Password do not match").css("color", "red");
                } else {
                    $("#label-msg").html("Password matched").css("color", "green");
                }
            });
            $("#txtconfirmpas").keyup(function () {
                if ($(".txtpassword").val() != $("#txtconfirmpas").val()) {
                    $("#label-msg").html("Password do not match").css("color", "red");
                } else {
                    $("#label-msg").html("Password matched").css("color", "green");
                }
            });
            showprofile();
            $(document).on('click',
                '#btnupdatepassword',
                function () {
                    $('#idupdatepassword').show();
                    var userInfo = {};
                    userInfo.oldPassword = $('#txtoldpass').val();
                    userInfo.Password = $('.txtpassword').val();
                    userInfo.GetId = <%=  Session["login_id"] %>;
                    $.ajax({
                        async: false,
                        url: '../webservices/AddUser.asmx/apichangepassword',
                        method: 'POST',
                        contentType: 'application/json;charset=utf-8',
                        data: '{objuserinfo:' + JSON.stringify(userInfo) + '}',
                        success: function (data) {
                            if (data[0].Varreturen == "Found") {
                                Swal({
                                    type: 'success',
                                    title: 'Your Password Have Been Change Successfully',
                                    showConfirmButton: false,
                                    timer: 1800
                                });
                                $('#txtoldpass').val("");
                                $('.txtpassword').val("");
                                $('#label-msg').hide();
                                $('#txtconpassword').val("");
                            }
                            else if (data[0].Varreturen == "Password Not Found") {
                                Swal({
                                    type: 'error',
                                    title: 'Old Password Not Match Please Correct Password Enter',
                                    showConfirmButton: false,
                                    timer: 1800
                                });
                            }
                            $('#idupdatepassword').hide();
                        },
                        error: function (jqXHR, exception) {
                            if (500 == 500) {
                                msg = 'Internal Server Error [500].';
                                Swal({
                                    type: 'error',
                                    title: 'Oops...',
                                    text: msg,
                                    showConfirmButton: false,
                                    timer: 1800
                                });
                                $('#label-msg').hide();

                                $('#idupdatepassword').hide();
                            }
                        }
                    });

                });
            $(document).on('click',
                '#btnupdateprofile',
                function () {
                    $('#idupdateprofile').show();
                    var userInfo = {};
                    userInfo.UserName = $('#txtxUsername').val();
                    userInfo.GetId = <%=  Session["login_id"] %>;
                    $.ajax({
                        async: false,
                        url: '../webservices/AddUser.asmx/apiprofileupdate',
                        method: 'POST',
                        contentType: 'application/json;charset=utf-8',
                        data: '{objuserinfo:' + JSON.stringify(userInfo) + '}',
                        success: function () {
                            showprofile();
                            Swal({
                                type: 'success',
                                title: 'User Profile Updated',
                                showConfirmButton: false,
                                timer: 1800
                            });
                            $('#idupdateprofile').hide();
                        },
                        error: function (jqXHR, exception) {
                            if (500 == 500) {
                                msg = 'Internal Server Error [500].';
                                Swal({
                                    type: 'error',
                                    title: 'Oops...',
                                    text: msg,
                                    showConfirmButton: false,
                                    timer: 1800
                                });
                                $('#idupdateprofile').hide();
                            }
                        }
                    });
                });



        });
        function showprofile() {
            var userInfo = {};
            userInfo.GetId = <%=  Session["login_id"] %>;
            $.ajax({
                async: false,
                url: '../webservices/AddUser.asmx/Getuserinfoidbase',
                method: 'POST',
                contentType: 'application/json;charset=utf-8',
                data: '{objuserinfo:' + JSON.stringify(userInfo) + '}',
                success: function (data) {
                    $('#txtxUsername').val(data[0].UserName);
                    $('#txtemail').val(data[0].Email);
                    $('.clsSpanUserName').html(data[0].UserName);
                    $('#txtcompanyname').val(data[0].company_name);
                },
                error: function (jqXHR, exception) {
                    if (500 == 500) {
                        msg = 'Internal Server Error [500].';
                        Swal({
                            type: 'error',
                            title: 'Oops...',
                            text: msg,
                            showConfirmButton: false,
                            timer: 1800
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
                                <h4 class="page-title">Profile</h4>
                                <div class="clearfix"></div>
                            </div>
                        </div>
                    </div>
                    <!-- end page title -->
                    <hr />
                        <div class="row">
                            <div class="col-12">
                                
                                <div class="col-md-6 col-sm-12 col-xs-12" style="float: left">

                                <div class="card">
                                    <div class="card-body table-responsive">
                    <div class="x_panel">
                        <div class="x_title">
                            <h2>Profile</h2>
                            <div class="clearfix"></div>
                        </div>
                        <div class="x_content">
                            <form>
                                <div class="form-group">
                                    <label>User Name</label>
                                    <input type="email" class="form-control" id="txtxUsername" placeholder="User Name" />
                                </div>
                                <div class="form-group">
                                    <label>Email address</label>
                                    <input type="email" class="form-control" disabled="disabled" id="txtemail" placeholder="E-mail" />
                                </div>
                                <button type="button" class="btn btn-success" id="btnupdateprofile"><i class="fa fa-refresh fa-spin" id="idupdateprofile" style="display: none;"></i>Update</button>
                            </form>
                        </div>
                    </div>
      
                </div>
                
                
            

                                    </div>
                                </div>
                             <div class="col-md-6 col-sm-12 col-xs-12" style="float: right">

                                <div class="card">
                                    <div class="card-body table-responsive">
               
                                        <div class="x_panel">
                                            <div class="x_title">
                                                <h2>Change Password</h2>
                                                <div class="clearfix"></div>
                                            </div>
                                            <div class="x_content">

                                                <div class="form-group">
                                                    <label>Old Password</label>
                                                    <input type="password" class="form-control" id="txtoldpass" placeholder="Old Password">
                                                </div>
                                                <div class="form-group">
                                                    <label>New Password</label>
                                                    <input id="events" type="password" class="form-control txtpassword" placeholder="New Password">
                                                </div>
                                                <div class="form-group">
                                                    <label>Confirm Password</label>
                                                    <input type="password" id="txtconpassword" placeholder="confirm password" class="form-control">
                                                </div>
                                                <div class="form-group">
                                                    <span id="label-msg" style="float: left;"></span>
                                                </div>
                                                <br />
                                                <button type="button" class="btn btn-success" id="btnupdatepassword"><i class="fa fa-refresh fa-spin" id="idupdatepassword" style="display: none;"></i>Update</button>

                                            </div>
                                        </div>
                </div>
                
                
              

                                    </div>
                                </div>
                        </div>
       
                </div>


            </div>


        </div>
            
    </div>
    <!-- sample modal content -->

    <!-- /.modal -->
    <!-- END wrapper -->
</asp:Content>

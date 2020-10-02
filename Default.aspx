<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="suitespk.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Login page</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="Responsive bootstrap 4 admin template" name="description" />
    <meta content="Coderthemes" name="author" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!-- App favicon -->
    <link rel="shortcut icon" href="assets/images/favicon.ico">
    <script src="assets/js/vendor.min.js"></script>
    <!-- App css -->
    <link href="assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" />
    <script src="assets/js/jquery.md5.js"></script>
    <link rel="stylesheet" href="./assets/css/toastr.min.css" />
    <link href="assets/libs/sweetalert2/sweetalert2.min.css" rel="stylesheet" type="text/css" />
    <script src="assets/libs/sweetalert2/sweetalert2.min.js"></script>
    <!-- Vendor js -->
    <script src="assets/libs/toastr/toastr.min.js"></script>
    


     <script>
        $(document).ready(function () {
            $('.emailsendbody').hide();


            $(document).on('click', '#btnlogin', function () {
                if ($('#txtemailaddress').val() == "") {
                    toastr["error"]("Enter E-mail");
                    $('#txtemailaddress').focus();
                    return false;
                }
                var UserInfo = {};
                UserInfo.Email = $('#txtemailaddress').val();
                UserInfo.Password = $('#txtpassword').val();
                $.ajax({
                    async: false,
                    type: "POST",
                    url: "../webservices/AddUser.asmx/userlogin",
                    cache: false,
                    contentType: "application/json; charset=utf-8",
                    data: '{objUserInfo:' + JSON.stringify(UserInfo) + '}',
                    dataType: "json",
                    success: function (data) {
                        if (data[0].Dataexist == "found") {

                            swal({
                                type: 'success',
                               title: 'User Have Been Login Successfully ',
                               icon: "success",
                                showConfirmButton: false,
                                timer: 2000

                            });
                          
                            window.location.href = "../dashboard.aspx";
                        }
                        else if (data[0].Dataexist =="Not Found")
                        {
                            swal({
                                type: 'error',
                                title: 'Oops...',
                                text: 'Invalid Username or Password!',
                                showConfirmButton: false,
                                timer: 2000
                            });
                        }
                    }
                });
            });
            $(document).on('click', '#btnforgot', function () {
                labelemail = $('#txtforgotemail').val();
                SendEmail = {};
                SendEmail.EmailAddress = labelemail;
                $.ajax({
                    async: false,
                    type: "POST",
                    url: "../Webservices/sendemail.asmx/GetUserName",
                    cache: false,
                    contentType: "application/json; charset=utf-8",
                    data: '{objSendEmail:' + JSON.stringify(SendEmail) + '}',
                    dataType: "json",
                    success: function (data) {
                        if (data[0].Dataexist != "not found") {
                            getusername = data[0].Dataexist;
                        }
                    }
                });
                //var hash = CryptoJS.MD5("Message");
                var password = $("#txtforgotemail").val();
                var getpassword = md5(password);
                var url = "http://" + $(location).attr('host') + "/forgot_password.aspx?key=" + getpassword;
                $('#geturl').attr("href", url);
                $('#getusername').empty();

                $('#getusername').append('Hi ' + getusername.toUpperCase());
                var gettable = $('.emailsendbody').html();
                SendEmail = {};
                SendEmail.EmailAddress = labelemail;
                SendEmail.Subject = "Forgot Password";
                SendEmail.EmailBody = gettable;
                SendEmail.getpassword = getpassword;
                $.ajax({
                    async: false,
                    type: "POST",
                    url: "../webservices/sendemail.asmx/ForgotPassword",
                    cache: false,
                    contentType: "application/json; charset=utf-8",
                    data: '{objSendEmail:' + JSON.stringify(SendEmail) + '}',
                    dataType: "json",
                    success: function (data) {
                        if (data[0].Dataexist == "Found") {
                            swal({
                                type: 'success',
                                title: 'Go To E-mail',
                                text: "An email will be sent to that '" + labelemail + " ' email address with a link to reset your password.",
                                showConfirmButton: false,
                            });
                            window.setTimeout(function () { window.location.href = "Default.aspx" }, 3000);
                        }
                        else if (data[0].Dataexist == "not found") {
                            swal({
                                type: 'error',
                                title: 'Go To E-mail',
                                text: "This E-mail Address Not Found '" + labelemail + "'",
                                showConfirmButton: false,

                            });
                        }

                    }
                });

            });
        });
       

    </script>
    
    
    <style>
        .justify-content-center {
            margin-top: 11%;
        }
    </style>

</head>
 <body class="authentication-page">

        <div class="account-pages my-5">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-8 col-lg-6 col-xl-5">
                        <div class="card mt-4">
                            <div class="card-header p-4 bg-primary">
                                <h4 class="text-white text-center mb-0 mt-0">Login Panel</h4>
                            </div>
                            <div class="card-body">
                                <form action="#" class="p-2">

                                    <div class="form-group mb-3">
                                        <label for="emailaddress">Email Address :</label>
                                        <input class="form-control" type="email" id="txtemailaddress" required="" placeholder="john@deo.com">
                                    </div>

                                    <div class="form-group mb-3">
                                        <label for="password">Password :</label>
                                        <input class="form-control" type="password" required="" id="txtpassword" placeholder="Enter your password">
                                    </div>
                                    <div class="form-group mb-3">
                                        <a href="#" class="text-muted float-right" data-toggle="modal" data-target="#myModal">Forgot your password?</a>
                                        <br/>

                                    </div>
                                    <div class="form-group mb-3">
                                        <button class="btn btn-md btn-block btn-primary waves-effect waves-light" type="button" id="btnlogin">Login In</button>
                                    </div>
                                
                                </form>

                            </div>
                            <!-- end card-body -->
                        </div>
                        <!-- end card -->

                        <!-- end row -->
                        
                        <div id="myModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" style="display: none;" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="card-header text-center p-4 bg-primary">
                                        <h4 class="text-white mb-0 mt-0">Reset Password</h4>
                                    </div>
                                    <div class="card-body">
                                        <form action="#" class="p-2">
                                            <div class="form-group mb-0">
                                                <div class="input-group">
                                                    <input type="text" id="txtforgotemail" class="form-control" placeholder="Enter Email">
                                                    <span class="input-group-append"> <button type="button" id="btnforgot" class="btn btn-primary">Reset Password</button> </span>
                                                </div>

                                            </div>
                                        </form>

                                    </div>
                        
                                </div>
                                <!-- /.modal-content -->
                            </div>
                            <!-- /.modal-dialog -->
                        </div>
                        
                        

                        
                   

                        
                    </div>
                    <!-- end col -->
                </div>
                <!-- end row -->

            </div>
        </div>

        <!-- Vendor js -->
        <script src="assets/js/vendor.min.js"></script>

        <!-- App js -->
        <script src="assets/js/app.min.js"></script>
 
 

         <div style="margin: 0pt auto; padding: 0px; background:#F7F7F7;" class="emailsendbody"> <table id="main" width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#F4F7FA"> <tbody> <tr> <td valign="top"> <table class="innermain" cellpadding="0" width="580" cellspacing="0" border="0" bgcolor="#F4F7FA" align="center" style="margin:0 auto; table-layout: fixed;"> <tbody> <!-- START of MAIL Content --> <tr> <td colspan="4"> <!-- Logo start here --> <table class="logo" width="100%" cellpadding="0" cellspacing="0" border="0"> <tbody> <tr> <td colspan="2" height="30"></td> </tr> <tr> <td valign="top" align="center"> <a href="https://www.genial365.com/" style="display:inline-block; cursor:pointer; text-align:center;">  </a> </td> </tr> <tr> <td colspan="2" height="30"></td> </tr> </tbody> </table> <!-- Logo end here --> <!-- Main CONTENT --> <table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff" style="border-radius: 4px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);"> <tbody> <tr> <td height="40"></td> </tr> <tr style="font-family: -apple-system,BlinkMacSystemFont,&#39;Segoe UI&#39;,&#39;Roboto&#39;,&#39;Oxygen&#39;,&#39;Ubuntu&#39;,&#39;Cantarell&#39;,&#39;Fira Sans&#39;,&#39;Droid Sans&#39;,&#39;Helvetica Neue&#39;,sans-serif; color:#4E5C6E; font-size:14px; line-height:20px; margin-top:20px;"> <td class="content" colspan="2" valign="top" align="center" style="padding-left:90px; padding-right:90px;"> <table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff"> <tbody> <tr> <td align="center" valign="bottom" colspan="2" cellpadding="3"> <img alt="Coinbase" width="80" src="https://cdn2.iconfinder.com/data/icons/scenarium-vol-2-1/128/021_lock_password_protection_encrypted_security-512.png" /> </td> </tr> <tr> <td height="30" &nbsp;=""></td> </tr> <tr> <td align="center"> <span style="color:#48545d;font-size:22px;line-height: 24px;" id="getusername">Reset Your Password </span> </td> </tr> <tr> <td height="24" &nbsp;=""></td> </tr> <tr> <td height="1" bgcolor="#DAE1E9"></td> </tr> <tr> <td height="24" &nbsp;=""></td> </tr> <tr> <td align="center"> <span style="color:#48545d;font-size:14px;line-height:24px;"> A Password Reset For Your Account Was Request <br />Please Clikc The Button Below To Change Your Password </span> </td> </tr> <tr> <td height="20" &nbsp;=""></td> </tr> <tr> <td valign="top" width="48%" align="center"> <span> <a href="" id="geturl" style="display:block; padding:15px 25px; background-color:#0087D1; color:#ffffff; border-radius:3px; text-decoration:none;">Reset Password</a> </span> </td> </tr> <tr> <td height="20" &nbsp;=""></td> </tr> <tr> <td align="center"> <img src="../img/hr.png" width="54" height="2" border="0"> </td> </tr> <tr> <td height="20" &nbsp;=""></td> </tr> <tr> <td align="center"> <p style="color:#a2a2a2; font-size:12px; line-height:17px; font-style:italic;">If you did not sign up for this account you can ignore this email and the account will be deleted.</p> </td> </tr> </tbody> </table> </td> </tr> <tr> <td height="60"></td> </tr> </tbody> </table> <!-- Main CONTENT end here --> <!-- PROMO column start here --> <!-- Show mobile promo 75% of the time --> <!-- PROMO column end here --> <!-- FOOTER start here --> <table width="100%" cellpadding="0" cellspacing="0" border="0"> <tbody> <tr> <td height="10">&nbsp;</td> </tr> <tr> <td valign="top" align="center"> <span style="font-family: -apple-system,BlinkMacSystemFont,&#39;Segoe UI&#39;,&#39;Roboto&#39;,&#39;Oxygen&#39;,&#39;Ubuntu&#39;,&#39;Cantarell&#39;,&#39;Fira Sans&#39;,&#39;Droid Sans&#39;,&#39;Helvetica Neue&#39;,sans-serif; color:#9EB0C9; font-size:10px;">&copy; <a href="https://www.genial365.com/" target="_blank" style="color: #9EB0C9 !important; font-weight: 700; text-decoration: none; font-size: 11px;">TechnoPur</a> 2019 </span> </td> </tr> <tr> <td height="50">&nbsp;</td> </tr> </tbody> </table> <!-- FOOTER end here --> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </div>

    </body>
</html>

<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="send_sms.aspx.cs" Inherits="suitespk.School.send_sms" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Send Sms</title>
        <script>
            $(document).ready(function () {
                GetPermisions()
                $(document).on('click', 'input[type="checkbox"]', function () {
                    var cls = $(this).attr("class");
                    cls = "." + cls + "1";
                    if ($(this).prop('checked') == true) {
                        $(cls).each(function () {
                            $(this).prop('checked', true);
                        });
                    } else {
                        $(cls).each(function () {
                            $(this).prop('checked', false);
                        });
                    }
                });
                $('#btnupdate').on('click', function () {
                    var btn = $(this);
                    btn.prop('disabled', true);
                    setTimeout(function () {
                        btn.prop('disabled', false);
                    }, 3000);
                    if ($('#txtgetroles').val() == '-1') {
                        toastr["error"]("Select Role Name First", "Alert");
                        $('#txtgetroles').focus();
                        return false;
                    }
                    var arrdate = [];
                    $('.clstrIdForUpdate').each(function (index, element) {
                        var getvaluecheckbox = {};
                        var chkStatus, getcheckboxid;
                        getcheckboxid = $(this).attr("id");
                        if ($(this).find('td:nth-child(2) input').prop('checked') == true) {
                            chkStatus = "unable";
                        } else {
                            chkStatus = "disable";
                        }
                        getvaluecheckbox.GetId = getcheckboxid;
                        getvaluecheckbox.GetStatus = chkStatus;
                        arrdate.push(getvaluecheckbox);

                    });
                    $.ajax({
                        async: false,
                        url: '../WebServices/AllowPagePermissions.asmx/UpdatePagePermissions',
                        method: 'POST',
                        contentType: 'application/json;charset=utf-8',
                        data: '{objpermission:' + JSON.stringify(arrdate) + '}',
                        success: function (data) {
                        },
                        error: function (jqXHR, exception) {
                            if (jqXHR.status == 500) {
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

                    Swal({
                        type: 'success',
                        title: 'Role Permission Successfuly',
                        showConfirmButton: false,
                        timer: 1800
                    });
                    window.location.href = '../AddNewUser/page_permissions.aspx';
                });
            });
            function GetPermisions() {
                var getroleid = {};
                getroleid.GetRoleId = $('#txtgetroles :selected').val();
                $.ajax({
                    async: false,
                    url: '../webservices/Send_SMS.asmx/GetRecord',
                    method: 'POST',
                    dataType: 'json',
                    success: function (data) {
                        var voucherOptions = $('.clsTable');
                        $('.clsTbodyAppended').remove();
                        var getmoduleid = 0;
                        $(data.GetClasses).each(function (index, getValue) {
                            var i = index;
                            //voucherOptions.empty();
                            voucherOptions.append('<tbody class="clsTbodyAppended" id="txtsubcategory' + index + '"><tr><td><b>' + getValue.classes_name + '</b></td><td><input type="checkbox" class="' + getValue.classes_id + '"></td></tr></tbody>');
                            var status = "";
                            var getvaluepagelink = $('#txtsubcategory' + i + '');
                            $(data.GetStudentName).each(function (index2, getValue2) {
                                if (getValue2.classes_id == getValue.classes_id) {
                                    getvaluepagelink.append('<tr id="' + getValue2.std_id + '" class="clstrIdForUpdate"><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + getValue2.std_name + '</td><td><input id="' + index2 + '" type="checkbox" class="' + getValue2.classes_id + '1"></td></tr>');
                                    status = true;

                                }

                            });

                            if (status=="") {
                                $('#txtsubcategory'+ i).remove();

                            }

                        });
                    },
                    error: function () {
                    }
                });
            }
    </script>
    <style>
        table thead th, td {
     text-align: left!important; 
}
    </style>
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
                                <h4 class="page-title">Send SMS</h4>

                                <div class="clearfix"></div>
                            </div>
                        </div>
                    </div>
                    <!-- end page title -->
                    <hr />
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">

                                    <div class="row">
                                        <div class="col-12">
                                            <div class="">
                                                <form class="form-horizontal">
                                                    <div class="form-group row">
                                                        <label class="col-lg-2 col-form-label">Text</label>
                                                        <div class="col-lg-10">
                                                            <textarea class="form-control" rows="5" id="example-textarea"></textarea>
                                                        </div>
                                                    </div>
                                                      
                                                    <table id="" class="clsTable table table-striped jambo_table" style="width: 100%">
                                                        <thead>
                                                        <tr>
                                                            <th>Student Name/Class</th>
                                                            <th>Action</th>
                                                        </tr>
                                                        </thead>
                                                    </table>
                                                    <input type="button" class="btn btn-primary" id="btnupdate" style="float: right;" value="Send Message">
                                                </form>
                                            </div>
                                        </div>

                                    </div>
                                    <!-- end row -->

                                </div>
                            </div>
                            <!-- end card -->
                        </div>
                        <!-- end col -->
                    </div>
       
                </div>


            </div>


        </div>
       
    </div>
    <!-- sample modal content -->

    <!-- /.modal -->
    <!-- END wrapper -->
</asp:Content>

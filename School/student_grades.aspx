<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="student_grades.aspx.cs" Inherits="suitespk.School.student_grades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Student Data</title>
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
                showclasses();
                clearallbox();

                $(".select2_single").select2({
                    placeholder: "",
                    allowClear: true
                });
            });
            showStdInfo();

            //Insert Student Info Script




            $('#btnaddstd').on('click', function () {
                var btn = $(this);
                btn.prop('disabled', true);
                setTimeout(function () {
                    btn.prop('disabled', false);
                }, 1000);
                if ($('#txtstdname').val() == "") {
                    toastr["error"]("Student name is required");
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

                if (Number($('#txtClassName').val()) <= 0) {
                    toastr["error"]("Class is required");
                    $('#txtClassName').focus();
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


                var addstudent = {};
                addstudent.std_name = $('#txtstdname').val();
                addstudent.std_lastname = $('#txtlastname').val();
                addstudent.std_father = $('#txtfathername').val();
                addstudent.std_gender = $('input[name=gender]:checked').val();
                addstudent.std_class = $('#txtClassName').val();
                addstudent.std_phone_no = $('#txtstdphone').val();
                addstudent.std_email = $('#txtemail').val();
                addstudent.std_password = $('#txtpassword').val();
                $.ajax({
                    async: false,
                    url: '../webservices/Svr_Add_Student.asmx/fnAddStd',
                    method: 'POST',
                    contentType: 'application/json;charset=utf-8',
                    data: '{ObjAddStd:' + JSON.stringify(addstudent) + '}',
                    success: function (data) {
                        if (data[0].Dataexist == "Not Found") {
                            swal({
                                title: "Done",
                                text: "Student info succefully saved.",
                                icon: "success",
                            });
                            // toastr["success"]("Teacher info succefully saved.");
                            showStdInfo();
                            $('#myModal').modal('toggle');
                        }
                        else if (data[0].Dataexist == "found_email") {
                            swal({
                                title: "info",
                                text: "Student E-mail Alread Exist",
                                icon: "success",
                            });
                        }
                        else {
                            swal({
                                title: "Info",
                                text: "Student Info Alread Exist",
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
            $('#btnSubmitAddSubject').on('click', function () {
                var btn = $(this);
                btn.prop('disabled', true);
                setTimeout(function () {
                    btn.prop('disabled', false);
                }, 1000);
                if ($('#txtSubjectName').val() == "") {
                    toastr["error"]("Subject Name is Required");
                    $('#txtSubjectName').focus();
                    return false;
                }
                if (Number($('#txtMarks').val()) == 0) {
                    toastr["error"]("Subject Total Marks is Required");
                    $('#txtMarks').focus();
                    return false;
                }




                var addstudent = {};
                addstudent.std_name = $('#txtSubjectName').val();
                addstudent.std_lastname = $('#txtMarks').val();

                $.ajax({
                    async: false,
                    url: '../webservices/AddSubjects.asmx/fnAddSubject',
                    method: 'POST',
                    contentType: 'application/json;charset=utf-8',
                    data: '{ObjAddStd:' + JSON.stringify(addstudent) + '}',
                    success: function (data) {
                        if (data[0].Dataexist == "Not Found") {
                            swal({
                                title: "Done",
                                text: "Subject Added Successfully.",
                                icon: "success",
                            });
                            // toastr["success"]("Teacher info succefully saved.");
                            showStdInfo();
                            $('#modelAddSubject').modal('toggle');
                        }
                        else if (data[0].Dataexist == "found_email") {
                            swal({
                                title: "info",
                                text: "Student E-mail Alread Exist",
                                icon: "success",
                            });
                        }
                        else {
                            swal({
                                title: "Info",
                                text: "Subject Alread Exist",
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
                showclasses();
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

                $('#txtClassName').val($tr.find('td:nth-child(6)').attr('id'));
                $('#txtstdphone').val($tr.find('td:nth-child(7)').text());
                $('#txtemail').val($tr.find('td:nth-child(8)').text());
                $('#txtpassword').val($tr.find('td:nth-child(7)').text());
                $(".select2_single").select2({
                    placeholder: "Select a Country",
                    allowClear: true
                });
            });

            //Update student info
            $(document).on('click', '#btnupdaterec', function () {
                var btn = $(this);
                btn.prop('disabled', true);
                setTimeout(function () {
                    btn.prop('disabled', false);
                }, 1000);
                if ($('#txtstdname').val() == "") {
                    toastr["error"]("Student name is required");
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

                if (Number($('#txtClassName').val()) <= 0) {
                    toastr["error"]("Class is required");
                    $('#txtClassName').focus();
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

                var addstudent = {};
                addstudent.std_name = $('#txtstdname').val();
                addstudent.std_lastname = $('#txtlastname').val();
                addstudent.std_father = $('#txtfathername').val();
                addstudent.std_gender = $('input[name=gender]:checked').val();
                addstudent.std_class = $('#txtClassName').val();
                addstudent.std_phone_no = $('#txtstdphone').val();
                addstudent.std_email = $('#txtemail').val();
                addstudent.std_password = $('#txtpassword').val();
                addstudent.std_id = StdInfoId;
                $.ajax({
                    async: false,
                    url: '../webservices/Svr_Add_Student.asmx/EditStdInfo',
                    method: 'POST',
                    contentType: 'application/json;charset=utf-8',
                    data: '{ObjEditStdInfo:' + JSON.stringify(addstudent) + '}',
                    success: function (data) {
                        swal({
                            title: "Done",
                            text: "Student info Successfully saved.",
                            icon: "success",
                        });
                        // toastr["success"]("Student info Successfully saved.");
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
            //Delete student info
           $(document).on('click', '.delstdinfo', function () {
                var StdInfoId = ($(this).attr("id"));
                var addstudent = {};
                addstudent.std_id = StdInfoId;
                if (confirm("Are you really want to delete this student info?") == true) {
                    $.ajax({
                        async: false,
                        url: '../webservices/Svr_Add_Student.asmx/DelStdInfo',
                        method: 'POST',
                        contentType: 'application/json;charset=utf-8',
                        data: '{ObjDelStdInfo:' + JSON.stringify(addstudent) + '}',
                        dataType: 'JSON',
                        success: function (data) {
                            swal({
                                title: "Done!",
                                text: "Student info successfully deleted.",
                                icon: "success",
                            });
                            // toastr["success"]("Student info successfully deleted.");
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
                        text: "Student info is saved.",
                        icon: "error",
                    });
                    return false;
                }
            });
           $(document).on('click', '.clsEditCol', function () {
               var ind = ($(this).attr("id"));
               $('.clsMarksBoxAll').attr("disabled", "disabled"); 
               $('.clsMarksBox' + ind).removeAttr("disabled");
           });
           $(document).on('focusout ', '.clsMarksBoxAll', function () {

               if ($(this).prop('disabled') == false) {
                   var subjectid = ($(this).attr("id"));
                   var subjectTotalMarks = ($(this).attr("name"));
                   var marks = Number($(this).val());
                   var stdId = $(this).closest('tr').attr('id');
                   if (Number(marks) > Number(subjectTotalMarks)) {
                       toastr["error"]("Obtained Marks cannot greater than total marks");
                       $(this).focus();
                       return false;
                   }
                   var addstudent = {};
                   addstudent.std_id = stdId;
                   addstudent.subjects_id = subjectid;
                   addstudent.std_marks = marks;
                   $.ajax({
                       //async: false,
                       url: '../webservices/AddGrades.asmx/UpdateMarks',
                       method: 'POST',
                       contentType: 'application/json;charset=utf-8',
                       data: '{ObjEditStdInfo:' + JSON.stringify(addstudent) + '}',
                       dataType: 'JSON',
                       success: function (data) {
                           toastr["success"]("Marks Updated");

                           // toastr["success"]("Student info successfully deleted.");
                           //showStdInfo();
                       },
                       error: function (jqXHR, exception) {
                           if (jqXHR.status == 500) {
                               toastr["error"]("Internal server error <b>[500]</b> occured");
                           }
                       }
                   });
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


        //showing student info in table
        function showStdInfo() {
            $.ajax({
                url: '../webservices/AddGrades.asmx/GetSubjects',
                async: false,
                method: 'POST',
                dataType: 'json',
                success: function (data) {
                    var subjectsName = [];
                    var subjectsId = [];
                    var subjectsMarks = [];

                    //getsubjects
                    $.ajax({
                        url: '../webservices/AddSubjects.asmx/GetSubjects',
                        async: false,
                        method: 'POST',
                        dataType: 'json',
                        success: function (data1) {
                            var totalSubjectMarks = 0;
                            $('.clsTheadSubject').remove()
                            $(data1).each(function (index, infostd) {
                                subjectsName.push(infostd.std_name)
                                subjectsId.push(infostd.std_id)
                                subjectsMarks.push(infostd.std_class)
                                totalSubjectMarks= Number(totalSubjectMarks) + Number(infostd.std_class)
                                $('#Thead').append('<th class="clsTheadSubject">' + infostd.std_name + '(' + infostd.std_class + ')  <span id="' + index+'" class="btn btn-primary btn-xs fa fa-edit clsEditCol"></span>  </th>')
                            });
                            var studentNames = [];
                            var studentId = [];
                            var voucherOptions = $('#rowstudents');
                            voucherOptions.empty();
                            $(data).each(function (index, infostd) {
                                if ($.inArray(infostd.std_id, studentId) == "-1" && Number(infostd.std_id) > 0) {
                                    studentNames.push(infostd.std_name + " " + infostd.std_lastname)
                                    studentId.push(infostd.std_id)
                                }
                            });
                            for (var i = 0; i < studentId.length; i++) {

                                //getStudentSubjectsMarks
                                var stdMarksTd = "";
                                var totalGotMarks =0;
                                for (var k = 0; k < subjectsId.length; k++) {
                                    var stdSubjectMarks = 0;
                                    $(data).each(function (index, infostd) {
                                        if (studentId[i] == infostd.std_id && subjectsId[k] == infostd.subjects_id) {
                                            stdSubjectMarks = infostd.std_marks;
                                            return false;
                                        }
                                    });
                                    stdMarksTd = stdMarksTd + '<td style="width: 7%;"><input id="' + subjectsId[k] + '" name="' + subjectsMarks[k] + '"  disabled class="form-control clsMarksBoxAll clsMarksBox' + k + '" value="' + stdSubjectMarks + '"/></td>'
                                    console.log(subjectsId[k] + "/" + studentId[i])
                                    totalGotMarks = Number(totalGotMarks) + Number(stdSubjectMarks);
                                }

                                voucherOptions.append('<tr id="' + studentId[i] + '"><td>' + (i + 1) + '</td> <td style="text-align:left" >' + studentNames[i] + '</td><td>' + totalGotMarks + '/' + totalSubjectMarks + ' (' + Number(Number(totalGotMarks) / Number(totalSubjectMarks) * 100).toFixed(2) + ' %)</td>' + stdMarksTd + '</tr>');
                            }
                        },
                        error: function (jqXHR, exception) {
                            alert("Error")
                        }
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
        function showclasses() {
            $.ajax({
                url: '../webservices/Svr_Add_Student.asmx/Getclasses',
                async: false,
                method: 'POST',
                dataType: 'json',
                success: function (data) {
                    var Showresult = $('#txtClassName');
                    Showresult.empty();
                    Showresult.append('<option value="-1">Select Class</option>');
                    $(data).each(function (index, getValue) {
                        Showresult.append('<option value="' + getValue.std_id + '">' + getValue.std_name + '</option>');
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
    <style>
       #rowstudents tr td{
            padding: .15rem;
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
                                <h4 class="page-title">All Student Records</h4>
                            </div>
                        </div>
                    </div>
                    <!-- end page title -->
                    <hr />
                    <button type="button" class="btn btn-primary" id="btnAddstd" data-toggle="modal" data-target="#myModal">Add New Student</button>
                    <button type="button" class="btn btn-primary" id="btnAddSubject" data-toggle="modal" data-target="#modelAddSubject">Add Subject</button>
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body table-responsive">
                                    <table id="" class="table table-bordered dt-responsive nowrap" style="border-collapse: collapse; border-spacing: 0; width: 100%;">

                                        <thead>
                                            <tr id="Thead">
                                                <th style="width: 6%;">Sr#</th>
                                                <th>Student Name</th>
                                                <th>Total(%)</th>
                                            </tr>


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
                        <h4 class="modal-title" id="insertHead"><strong>Add Student Info</strong></h4>
                        <h4 class="modal-title" id="updateHead"><strong>Edit Student Info</strong></h4>
                        <!--<button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">×</button>-->
                    </div>
                    <div class="modal-body">
                        <form class="" action="#" autocomplete="off" method="post">
                            <div class="form-group">
                                <label for="txtstdname">Student Name<span class="text-danger">*</span></label>
                                <input id="txtstdname" type="text" name="txtstdname" placeholder="Enter student name" class="form-control" />
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
                                <input type="radio" name="gender" value="male">
                                Male
                            <input type="radio" name="gender" value="female">
                                Female
                            <input type="radio" name="gender" value="other">
                                Other                       
                            </div>
                            <div class="form-group">
                                <label for="classname">Student Class<span class="text-danger">*</span></label>
                                <select class="select2_single form-control" style="width: 100%;" tabindex="-1" id="txtClassName">
                                </select>
                            </div>
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
                        <button type="button" class="btn btn-primary" id="btnaddstd">Save</button>
                        <button type="button" class="btn btn-info" id="btnupdaterec">Done Edit</button>
                    </div>

                </div>
                <!-- /.modal-content -->
            </div>
            <!-- /.modal-dialog -->
        </div>
        <div id="modelAddSubject" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" style="display: none;" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title" id=""><strong>Add Subject</strong></h4>
                        <!--<button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">×</button>-->
                    </div>
                    <div class="modal-body">
                        <form class="" action="#" autocomplete="off" method="post">
                            <div class="form-group">
                                <label for="txtstdname">Subject Name<span class="text-danger">*</span></label>
                                <input id="txtSubjectName" type="text" name="txtstdname" placeholder="Enter Subject name" class="form-control" />
                            </div>
                            <div class="form-group">
                                <label for="fname">Total Marks</label>
                                <input id="txtMarks" type="number" name="txtlastname" placeholder="Enter Total Marks" class="form-control" />
                            </div>

                            <hr />
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary waves-effect" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="btnSubmitAddSubject">Save New Subject</button>
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

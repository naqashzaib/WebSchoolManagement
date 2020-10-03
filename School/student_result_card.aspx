<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="student_result_card.aspx.cs" Inherits="suitespk.student_result_card" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Student Data</title>
    <script>
        $(document).ready(function () {
            //html styles
            $('button').css('border-radius', '0px');
            $('input').css('border-radius', '0px');
            $('.modal-content').css('border-radius', '0px');

            showStdInfo();

            //Insert Student Info Script


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

            $('#btnPrintReport').click(function () {


                $('.head').attr("style", "color: black; background-color:white; border:2px solid black ");
                $('#tblBalanceSheet').attr("style", "width: 100%; max-width: 100%; margin-top: 7px; font-siz:12px;  font-family: calibri;  ");
                $('#tblBalanceSheet tbody tr').attr("style", "line-height:8px; font-size:11px;");


                $('#tblBalanceSheet tbody').attr("style", " font-size:9px;");
                $('#tblBalanceSheet thead').attr("style", "line-height:10px; font-size:12px");
                $('#tblBalanceSheet').attr("border", "1px ");
                $('#tblBalanceSheet').attr("cellpadding", "5px ");
                $('#tblBalanceSheet').attr("cellspacing", "0px ");


                $('.divToPrint').attr("style", "font-family: calibri; font-size:12px  ");
                $('.green1').attr("style", "font-weight:bold; background:	 #cccccc; ");
                $('#Ledgerheader').show();

                $('#btnPrintReport').hide();
                printData();
                $('#btnPrintReport').show();
                $('#Ledgerheader').hide();
                $('.divToPrint').attr("style", " ");

                $('#divProfile').hide();
                $('#divProfile').attr("style", " ");
                $('#tblBalanceSheet tbody tr').attr("style", "");
                //$('#tblBalanceSheet tbody').attr("style", " font-size:9px;");
                $('#tblBalanceSheet thead').attr("style", "");

                $('#tblBalanceSheet').attr("style", "  ");
                $('#tblBalanceSheet').attr("border", " ");
                $('#tblBalanceSheet').attr("cellpadding", " ");
                $('.head').attr("style", " ");


                $('.head').attr("style", "");
                $('#tblBalanceSheet').attr("style", "");
                $('#tblBalanceSheet tbody tr').attr("style", "");


                $('#tblBalanceSheet tbody').attr("style", " ");
                $('#tblBalanceSheet thead').attr("style", "");
                $('#tblBalanceSheet').attr("border", " ");
                $('#tblBalanceSheet').attr("cellpadding", " ");
                $('#tblBalanceSheet').attr("cellspacing", " ");


                $('.divToPrint').attr("style", "  ");

            });

        });

        function printData() {


            var divToPrint = document.getElementById("divtoprint");
            newWin = window.open("");

            newWin.document.write(divToPrint.outerHTML);

            newWin.print();
            newWin.close();
        }



        //showing student info in table
        function showStdInfo() {
            
         
            var addstudent = {};
            addstudent.std_id = localStorage['adminid'];


            $.ajax({
                url: '../webservices/AddGrades.asmx/GetStudentCard',
                async: false,
                method: 'POST',
                dataType: 'json',
                contentType: 'application/json;charset=utf-8',
                data: '{addstudent:' + JSON.stringify(addstudent) + '}',
                success: function (data) {

                    $.ajax({
                        url: '../webservices/AddGrades.asmx/GetPositions',
                        method: 'POST',
                        dataType: 'json',
                        success: function (data21) {
                            $(data21).each(function (index, infostd) {
                                if (Number(infostd.std_id) == Number(data[0].std_id)) {
                                    $('#spanPosition').html(index + 1);

                                }

                            })
                        },
                        error: function (jqXHR, exception) {
                            alert("Error")
                        }
                    });



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
                                totalSubjectMarks = Number(totalSubjectMarks) + Number(infostd.std_class)
                                //$('#Thead').append('<th class="clsTheadSubject head">' + infostd.std_name + '(' + infostd.std_class + ')   </th>')
                            });
                            var studentNames = [];
                            var studentId = [];
                            var voucherOptions = $('#rowstudents');
                            voucherOptions.empty();
                            $(data).each(function (index, infostd) {
                                if ($.inArray(infostd.std_id, studentId) == "-1" && Number(infostd.std_id) > 0) {
                                    studentNames.push(infostd.std_name + " " + infostd.std_lastname)
                                    $('#spanStudnetName').html(infostd.std_name + " " + infostd.std_lastname)

                                    studentId.push(infostd.std_id)
                                }
                            });
                            for (var i = 0; i < studentId.length; i++) {

                                //getStudentSubjectsMarks
                                var stdMarksTd = "";
                                var totalGotMarks = 0;
                                for (var k = 0; k < subjectsId.length; k++) {
                                    var stdSubjectMarks = 0;
                                    $(data).each(function (index, infostd) {
                                        if (studentId[i] == infostd.std_id && subjectsId[k] == infostd.subjects_id) {
                                            stdSubjectMarks = infostd.std_marks;
                                            return false;
                                        }
                                    });
                                    stdMarksTd = stdMarksTd + '<td >' + stdSubjectMarks + '</td>'
                                    console.log(subjectsId[k] + "/" + studentId[i])
                                    totalGotMarks = Number(totalGotMarks) + Number(stdSubjectMarks);
                                    var marksPercent = Number(Number(stdSubjectMarks) / Number(subjectsMarks[k]) * 100).toFixed(2);

                                    var gradeOfSubject = "";
                                    if (Number(marksPercent) > 79) {
                                        gradeOfSubject = "<span style='color:green'>A</span>";
                                    } else if (Number(marksPercent) <= 79 && Number(marksPercent) > 65) {
                                        gradeOfSubject = "<span style='color:green'>B</span>";

                                    } else if (Number(marksPercent) <= 64 && Number(marksPercent) > 50) {
                                        gradeOfSubject = "<span style='color:green'>C</span>";

                                    } else if (Number(marksPercent) <= 50 && Number(marksPercent) > 33) {
                                        gradeOfSubject = "<span style='color:brown'>D</span>";

                                    } else {
                                        gradeOfSubject = "<span style='color:red'>F</span>";

                                    }
                                    voucherOptions.append('<tr i><td>' + (k + 1) + '</td> <td style="text-align:left;   " >' + subjectsName[k] + '</td><td style=" background: #f3ebcf;" >' + subjectsMarks[k] + '</td><td style=" background: #f3ebcf;" >' + stdSubjectMarks + '</td><td  style=" background: #f3ebcf;">' + marksPercent + '</td><td>' + gradeOfSubject + '</td></tr>');

                                }

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

    </script>
    <style>
        #rowstudents tr td {
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
                <div id="divtoprint" class="container-fluid">

                    <!-- start page title -->
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">

                                <h4 class="page-title col-10">Student Marks Detail 

                                </h4>
                                <input style="float: right" value="Print" id="btnPrintReport" type="button" class="btn btn-primary btn-xs pull-right col-2 " />

                            </div>
                        </div>
                    </div>
                    <!-- end page title -->
                    <hr />
                    <div class="row">

                        <div class="col-12">

                            <div class="card">

                                <div class="card-body table-responsive">
                                    <h4><span style="color: #3bc0c3;">Student Name:</span> <span id="spanStudnetName"></span></h4>

                                    <table id="tblBalanceSheet" class="table table-bordered dt-responsive nowrap" style="border-collapse: collapse; border-spacing: 0; width: 100%;">

                                        <thead>
                                            <tr id="Thead">
                                                <th class="head" style="width: 6%;">Sr#</th>
                                                <th class="head">Subject Name</th>
                                                <th class="head">Total Marks</th>
                                                <th class="head">Obtained Marks</th>
                                                <th class="head">Percentage(%)</th>
                                                <th class="head">Grade</th>
                                            </tr>


                                        </thead>
                                        <tbody id="rowstudents">
                                        </tbody>
                                    </table>
                                    <h4><span style="color: #3bc0c3;">Position in Class: </span><span id="spanPosition"></span></h4>
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



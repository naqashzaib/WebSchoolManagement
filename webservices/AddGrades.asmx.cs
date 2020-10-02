using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.Util;
using suitespk.classes;
namespace suitespk.webservices
{
    /// <summary>
    /// Summary description for AddGrades
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class AddGrades : System.Web.Services.WebService
    {
      public  class clsStd
        {
            public string std_id;
            public string std_name;
            public string std_lastname;
            public string subjects_id;
            public string subjects_name;
            public string marks_id;
            public string std_marks;

        }
        [WebMethod]
        public void UpdateMarks(clsStd ObjEditStdInfo)
        {
            List<recexist> listrecexist = new List<recexist>();
            listrecexist.Clear();
            string ConnectionString = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection objcon = new SqlConnection(ConnectionString))
            {
                objcon.Open();
                SqlCommand cmd3 = new SqlCommand("SELECT marks_id FROM marks WHERE subjects_id ='" + ObjEditStdInfo.subjects_id + "' and std_id ='" + ObjEditStdInfo.std_id + "' ", objcon);
                SqlDataReader re = null;
                re = cmd3.ExecuteReader();
                if (re.HasRows)
                {
                    string marksId = "";
                    while (re.Read())
                    {
                        marksId = re["marks_id"].ToString();
                    }
                    objcon.Close();
                    objcon.Open();
                    SqlCommand cmnd2 = new SqlCommand("UPDATE marks SET std_marks ='" + ObjEditStdInfo.std_marks + "' WHERE marks_id= '" + marksId + "'", objcon);
                    cmnd2.ExecuteNonQuery();
                    objcon.Close();
                    recexist Objrecexist = new recexist();
                    Objrecexist.Dataexist = "found";
                    listrecexist.Add(Objrecexist);
                }
                else
                {
                    objcon.Close();
                    objcon.Open();
                    SqlCommand cmnd2 = new SqlCommand("insert  into marks (std_marks,std_id,subjects_id) values('" + ObjEditStdInfo.std_marks + "','" + ObjEditStdInfo.std_id + "' ,'" + ObjEditStdInfo.subjects_id + "')", objcon);
                    cmnd2.ExecuteNonQuery();
                    objcon.Close();
                    recexist Objrecexist = new recexist();
                    Objrecexist.Dataexist = "Not Found";
                    listrecexist.Add(Objrecexist);
                }
                objcon.Close();
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listrecexist).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listrecexist));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }

        [WebMethod]
        public void GetSubjects()
        {
            List<clsStd> listStdInfo = new List<clsStd>();
            listStdInfo.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("select add_std_info.std_id,add_std_info.std_name,  add_std_info.std_lastname,subjects.subjects_id, subjects.subjects_name, marks.marks_id, marks.std_marks  from add_std_info left join  marks on  add_std_info.std_id=marks.std_id   left join subjects on subjects.subjects_id=marks.subjects_id order by add_std_info.std_name, subjects.subjects_name", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    clsStd StdInfo = new clsStd();
                    StdInfo.std_id = rdr["std_id"].ToString();
                    StdInfo.std_name = rdr["std_name"].ToString();
                    StdInfo.std_lastname = rdr["std_lastname"].ToString();
                    StdInfo.subjects_id = rdr["subjects_id"].ToString();
                    StdInfo.subjects_name = rdr["subjects_name"].ToString();
                    StdInfo.marks_id = rdr["marks_id"].ToString();
                    StdInfo.std_marks = rdr["std_marks"].ToString();

                    listStdInfo.Add(StdInfo);
                }
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listStdInfo).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listStdInfo));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        [WebMethod]
        public void GetStudentCard(clsStd addstudent)
        {
            List<clsStd> listStdInfo = new List<clsStd>();
            listStdInfo.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("select add_std_info.std_id,add_std_info.std_name,  add_std_info.std_lastname,subjects.subjects_id, subjects.subjects_name, marks.marks_id, marks.std_marks  from add_std_info left join  marks on  add_std_info.std_id=marks.std_id   left join subjects on subjects.subjects_id=marks.subjects_id where add_std_info.std_id='" + addstudent.std_id + "' order by add_std_info.std_name, subjects.subjects_name", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    clsStd StdInfo = new clsStd();
                    StdInfo.std_id = rdr["std_id"].ToString();
                    StdInfo.std_name = rdr["std_name"].ToString();
                    StdInfo.std_lastname = rdr["std_lastname"].ToString();
                    StdInfo.subjects_id = rdr["subjects_id"].ToString();
                    StdInfo.subjects_name = rdr["subjects_name"].ToString();
                    StdInfo.marks_id = rdr["marks_id"].ToString();
                    StdInfo.std_marks = rdr["std_marks"].ToString();

                    listStdInfo.Add(StdInfo);
                }
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listStdInfo).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listStdInfo));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
   [WebMethod]
        public void GetPositions()
        {
            List<clsStd> listStdInfo = new List<clsStd>();
            listStdInfo.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("select sum(cast(marks.std_marks as float)) as marks , add_std_info.std_id  from add_std_info , marks where add_std_info.std_id=marks.std_id group by  add_std_info.std_id order by  marks desc", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    clsStd StdInfo = new clsStd();
                    StdInfo.std_id = rdr["std_id"].ToString();
                  
                    StdInfo.std_marks = rdr["marks"].ToString();

                    listStdInfo.Add(StdInfo);
                }
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listStdInfo).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listStdInfo));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }

    }
}

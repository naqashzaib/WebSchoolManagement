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
using suitespk.classes;

namespace suitespk.webservices
{
    /// <summary>
    /// Summary description for AddUser
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class AddUser : System.Web.Services.WebService
    {
        [WebMethod(EnableSession = true)]
        public void Getuserinfoidbase(UserInfo objuserinfo)
        {
            List<UserInfo> objuserUserInfo = new List<UserInfo>();
            objuserUserInfo.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Close();
                con.Open();
                SqlCommand cmd = new SqlCommand("select * from login where login.login_id='" + objuserinfo.GetId + "'", con);
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    UserInfo objInsertValueUser = new UserInfo();
                    objInsertValueUser.GetId = Convert.ToInt32(rdr["login_id"].ToString());
                    objInsertValueUser.UserName = rdr["login_name"].ToString();
                    objInsertValueUser.UserType = rdr["login_type"].ToString();
                    objInsertValueUser.Email = rdr["login_email"].ToString();
                    objuserUserInfo.Add(objInsertValueUser);
                }
                con.Close();
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(objuserUserInfo).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(objuserUserInfo));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        [WebMethod(EnableSession = true)]
        private string GetMD5HashData(string data)
        {
            //create new instance of md5
            MD5 md5 = MD5.Create();
            //convert the input text to array of bytes
            byte[] hashData = md5.ComputeHash(Encoding.Default.GetBytes(data));
            //create new instance of StringBuilder to save hashed data
            StringBuilder returnValue = new StringBuilder();
            //loop for each byte and add it to StringBuilder
            for (int i = 0; i < hashData.Length; i++)
            {
                returnValue.Append(hashData[i].ToString());
            }
            // return hexadecimal string
            return returnValue.ToString();
        }
        [WebMethod(EnableSession = true)]
        public void apichangepassword(UserInfo objuserinfo)
        {
            List<UserInfo> listgetuserinfo = new List<UserInfo>();
            listgetuserinfo.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection objcon = new SqlConnection(cs))
            {
                objcon.Close();
                objcon.Open();
                SqlCommand objcomm = new SqlCommand("select * from login where login_id='" + objuserinfo.GetId + "'", objcon);

                objcomm.ExecuteNonQuery();
                SqlDataAdapter objadp = new SqlDataAdapter(objcomm.CommandText, objcon);
                DataTable dta2 = new DataTable();
                objadp.Fill(dta2);
                string VarNewPassword, VarOldPassword, VarOldPassword2;
                VarNewPassword = GetMD5HashData(objuserinfo.Password);
                VarOldPassword2 = GetMD5HashData(objuserinfo.oldPassword);
                foreach (DataRow dtrow3 in dta2.Rows)
                {
                    VarOldPassword = Convert.ToString(dtrow3["login_password"].ToString());
                    if (VarOldPassword == VarOldPassword2)
                    {
                        objcon.Close();
                        objcon.Open();
                        SqlTransaction objinserttrans1;
                        objinserttrans1 = objcon.BeginTransaction();
                        SqlCommand objcomm2 =
                            new SqlCommand(
                                "update login set login_password='" + VarNewPassword + "' where login_id='" + objuserinfo.GetId + "'",
                                objcon);
                        objcomm2.Transaction = objinserttrans1;
                        objcomm2.ExecuteNonQuery();
                        objinserttrans1.Commit();
                        objcon.Close();
                        UserInfo objclsuserinfo = new UserInfo();
                        objclsuserinfo.Varreturen = "Found";
                        listgetuserinfo.Add(objclsuserinfo);
                    }
                    else
                    {
                        UserInfo objclsuserinfo = new UserInfo();
                        objclsuserinfo.Varreturen = "Password Not Found";
                        listgetuserinfo.Add(objclsuserinfo);
                    }
                }
                objcon.Close();
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listgetuserinfo).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listgetuserinfo));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        [WebMethod(EnableSession = true)]
        public void apiprofileupdate(UserInfo objuserinfo)
        {
            List<recexist> listdataexist = new List<recexist>();
            listdataexist.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Close();
                con.Open();
                SqlCommand cmd =
                     new SqlCommand(
                        "update login set login_name='" + objuserinfo.UserName + "' where login_id='" + objuserinfo.GetId + "'", con);
                cmd.ExecuteNonQuery();
                con.Close();
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listdataexist).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listdataexist));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }


        private SqlDataAdapter objadp;
        private DataTable dtr;
        string email, pass, uuseername;

        [WebMethod(EnableSession = true)]
        public void userlogin(UserInfo objUserInfo)
        {
            List<recexist> listrecexist = new List<recexist>();
            listrecexist.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(cs))
            {
                connection.Open();
                SqlCommand command = connection.CreateCommand();
                SqlTransaction transaction;
                transaction = connection.BeginTransaction("SampleTransaction");
                command.Connection = connection;
                command.Transaction = transaction;
                string varPassword = GetMD5HashData(objUserInfo.Password);
                string exist = "";
                command.CommandText = "SELECT * FROM  login WHERE   login_email ='" + objUserInfo.Email + "' AND login_password ='" + varPassword + "'";
                objadp = new SqlDataAdapter(command.CommandText, connection);
                objadp.SelectCommand.Transaction = transaction;
                dtr = new DataTable();
                objadp.Fill(dtr);
                foreach (DataRow dtrow in dtr.Rows)
                {


                    email = dtrow["login_email"].ToString();
                    uuseername = dtrow["login_name"].ToString();
                    pass = dtrow["login_password"].ToString();
                    if (varPassword == pass)
                    {
                        Session["username"] = dtrow["login_name"].ToString();
                        Session["email"] = dtrow["login_email"].ToString();
                        Session["login_id"] = dtrow["login_id"].ToString();
                        Session["userrole"] = dtrow["login_type"].ToString();
                    }
                    recexist Objrecexist = new recexist();
                    Objrecexist.Dataexist = "found";
                    listrecexist.Add(Objrecexist);
                    exist = "found";
                }
                if (exist == "")
                {

                    recexist Objrecexist = new recexist();
                    Objrecexist.Dataexist = "Not Found";
                    listrecexist.Add(Objrecexist);
                }
                transaction.Commit();
            }



            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listrecexist).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listrecexist));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        [WebMethod(EnableSession = true)]
        public void userLofOut()
        {
            Session.Clear();

        }
        [WebMethod]
        public void FotgotPasswordUpdate(UserInfo objUserInfo)
        {
            List<recexist> listdataexist = new List<recexist>();
            listdataexist.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd2 =
                    new SqlCommand(
                        "select * from login where forgot_key='" + objUserInfo.Email + "'", con);
                SqlDataReader re = null;
                re = cmd2.ExecuteReader();
                if (!(re.HasRows))
                {
                    recexist objdataexist = new recexist();
                    objdataexist.Dataexist = "not found";
                    listdataexist.Add(objdataexist);
                    con.Close();
                }
                else
                {
                    string varPassword = GetMD5HashData(objUserInfo.Password);
                    con.Close();
                    con.Open();
                    SqlCommand cmd =
                        new SqlCommand("update login set login_password='" + varPassword + "' where forgot_key='" + objUserInfo.Email + "'", con);
                    cmd.ExecuteNonQuery();
                    con.Close();
                    con.Open();
                    SqlCommand cmd3 =
                        new SqlCommand("update login set forgot_key='' where forgot_key='" + objUserInfo.Email + "'", con);
                    cmd3.ExecuteNonQuery();
                    con.Close();
                    recexist objdataexist = new recexist();
                    objdataexist.Dataexist = "Found";
                    listdataexist.Add(objdataexist);
                }
                con.Close();
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listdataexist).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listdataexist));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }

    }
}

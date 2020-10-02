using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using suitespk.classes;

namespace suitespk.webservices
{
    /// <summary>
    /// Summary description for sendemail
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class sendemail : System.Web.Services.WebService
    {

        public string from, to, subject;
        public string status, getuserid, useremail;

        [WebMethod(EnableSession = true)]

        public void GetUserName(SendEmail objSendEmail)
        {
            List<recexist> listdataexist = new List<recexist>();
            listdataexist.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(cs))
            {
                connection.Open();
                SqlCommand command = connection.CreateCommand();
                SqlTransaction transaction;
                transaction = connection.BeginTransaction("SampleTransaction");
                command.Connection = connection;
                command.Transaction = transaction;
                command.CommandText = "select * from login where login_email ='" + objSendEmail.EmailAddress + "'";
                SqlDataReader re = null;
                re = command.ExecuteReader();
                if (re.HasRows)
                {
                    while (re.Read())
                    {
                        recexist objdataexist = new recexist();
                        objdataexist.Dataexist = Convert.ToString(re["login_name"].ToString());
                        listdataexist.Add(objdataexist);
                    }
                }
                else
                {
                    status = Convert.ToString(re["status"].ToString());
                    recexist objdataexist = new recexist();
                    objdataexist.Dataexist = "Not Found";
                    listdataexist.Add(objdataexist);
                }
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listdataexist).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listdataexist));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        [WebMethod(EnableSession = true)]

        public void ForgotPassword(SendEmail objSendEmail)
        {
            List<recexist> listdataexist = new List<recexist>();
            listdataexist.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(cs))
            {
                connection.Open();
                SqlCommand command = connection.CreateCommand();
                SqlTransaction transaction;
                transaction = connection.BeginTransaction("SampleTransaction");
                command.Connection = connection;
                command.Transaction = transaction;
                command.CommandText = "select * from login where login_email ='" + objSendEmail.EmailAddress + "'";
                SqlDataReader re = null;
                re = command.ExecuteReader();
                if (re.HasRows)
                {
                    re.Close();
                    command.CommandText = "update login set forgot_key='" + objSendEmail.getpassword + "' where  login_email ='" + objSendEmail.EmailAddress + "'";
                    command.ExecuteNonQuery();
                    transaction.Commit();
                    string htmlbody = objSendEmail.EmailBody;
                    SmtpClient client = new SmtpClient();
                    client.Port = 587;
                    client.Host = "smtp.gmail.com";
                    client.EnableSsl = true;
                    client.DeliveryMethod = SmtpDeliveryMethod.Network;
                    client.UseDefaultCredentials = false;
                    client.Credentials = new NetworkCredential("naqash031@gmail.com", "naqash12");
                    MailMessage mm = new MailMessage(objSendEmail.EmailAddress, objSendEmail.EmailAddress, objSendEmail.Subject, htmlbody);
                    mm.From = new MailAddress("naqash031@gmail.com", "Farooq Tech");
                    mm.IsBodyHtml = true;
                    mm.Priority = MailPriority.Normal;
                    mm.ReplyToList.Add("naqash031@gmail.com");
                    mm.BodyEncoding = Encoding.Default;
                    mm.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                    client.Send(mm);
                    recexist objdataexist = new recexist();
                    objdataexist.Dataexist = "Found";
                    listdataexist.Add(objdataexist);
                }
                else
                {
                    recexist objdataexist = new recexist();
                    objdataexist.Dataexist = "not found";
                    listdataexist.Add(objdataexist);
                }

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

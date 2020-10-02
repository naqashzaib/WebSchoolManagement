using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace suitespk.classes
{
    public class SendEmail
    {
        public string EmailAddress { get; set; }
        public string Subject { get; set; }
        public string EmailBody { get; set; }
        public string To { get; set; }
        public string cc { get; set; }
        public string getpassword { get; set; }
    }
}
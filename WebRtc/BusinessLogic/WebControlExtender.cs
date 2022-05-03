using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;

namespace WebRtc.BusinessLogic
{
    public static class WebControlExtender
    {
        //public static Control FindControlRecursive(this Control root, string id)
        //{
        //    if (root.ID == id)
        //    {
        //        return root;
        //    }

        //    foreach (Control c in root.Controls)
        //    {
        //        Control t = FindControlRecursive(c, id);
        //        if (t != null)
        //        {
        //            return t;
        //        }
        //    }

        //    return null;
        //}

        public static IEnumerable<Control> Flatten(this ControlCollection controls)
        {
            List<Control> list = new List<Control>();
            controls.Traverse(c => list.Add(c));
            return list;
        }

        public static IEnumerable<Control> Flatten(this ControlCollection controls,
            Func<Control, bool> predicate)
        {
            List<Control> list = new List<Control>();
            controls.Traverse(c => { if (predicate(c)) list.Add(c); });
            return list;
        }

        public static void Traverse(this ControlCollection controls, Action<Control> action)
        {
            foreach (Control control in controls)
            {
                action(control);
                if (control.HasControls())
                {
                    control.Controls.Traverse(action);
                }
            }
        }

        public static Control GetControl(this Control control, string id)
        {
            return control.Controls.Flatten(c => c.ID == id).SingleOrDefault();
        }

        public static IEnumerable<Control> GetControls(this Control control)
        {
            return control.Controls.Flatten();
        }
    }
}
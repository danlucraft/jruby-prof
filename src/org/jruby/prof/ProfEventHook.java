
package org.jruby.prof;

import org.jruby.prof.JRubyProf;

import org.jruby.RubyObject;
import org.jruby.RubyModule;
import org.jruby.MetaClass;
import org.jruby.runtime.EventHook;
import org.jruby.runtime.RubyEvent;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;

public class ProfEventHook extends EventHook {
    public void eventHandler(ThreadContext context, String eventName, String file, int line, String methodName, IRubyObject type) {
        RubyModule module = (RubyModule) type;
        String className;
        boolean isStatic = false;
        if (module == null) {
            className = "null";
        }
        else {
            if (module instanceof MetaClass) {
                IRubyObject obj = ((MetaClass) module).getAttached();
                if (obj instanceof RubyModule) {
                    module = (RubyModule) obj;
                    className = module.getName();
                    isStatic = true;
                }
                else if (obj instanceof RubyObject) {
                    className = "<Instance::" + ((RubyObject) obj).getType().getName() + ">";
                }
                else {
                    className = "unknown";
                }
            }
            else {
                className = module.getName();
            }
        }
        //System.out.printf("eventHandler(_, %s, %s, %d, %s, %s)\n", eventName, file, line, methodName, className);
        if (className.equals("Java::OrgJrubyProf::JRubyProf")) return;
        if (eventName.equals("call") || eventName.equals("c-call")) {
            JRubyProf.before(context, className, methodName, isStatic);
        }
        else if (eventName.equals("return") || eventName.equals("c-return")) {
             JRubyProf.after(context, className, methodName, isStatic);
       }
    }
    public boolean isInterestedInEvent(RubyEvent event) { return true; }
}
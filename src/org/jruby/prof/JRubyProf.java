
package org.jruby.prof;

import java.util.*;
import org.jruby.Ruby;
import org.jruby.runtime.ThreadContext;

public class JRubyProf {

    public static Map<ThreadContext, Invocation> currentInvocations;

    public static void printHello() {
        System.out.printf("hello: %s\n", Ruby.getGlobalRuntime().toString());
    }
    
    public static ProfEventHook hook = null;
    
    public static void start() {
        hook = new ProfEventHook();
        Ruby.getGlobalRuntime().addEventHook(hook);
        currentInvocations = Collections.synchronizedMap(new HashMap<ThreadContext, Invocation>());
        System.out.printf("starting tracing...\n");
        shouldProfile = true;
    }
    
    public static void stop() {
        System.out.printf("stopped tracing.\n");
        shouldProfile = false;
        Ruby.getGlobalRuntime().removeEventHook(hook);
        hook = null;
    }

    private static boolean shouldProfile = false;
    private boolean initProfileMethod = false;

    public static void before(ThreadContext context, String className, String methodName) {
        if (!shouldProfile) return;
        Invocation inv = null;
        if (currentInvocations.containsKey(context)) {
            Invocation parent = currentInvocations.get(context);
            for (Invocation subinv : parent.children) {
                if (subinv.className.equals(className) && subinv.methodName.equals(methodName)) {
                    inv = subinv;
                }
            }
            if (inv == null) {
                inv = new Invocation();
                inv.parent = parent;
                inv.className = className;
                inv.methodName = methodName;
                inv.frame = context.getCurrentFrame().hashCode();
                parent.children.add(inv);
            }
            currentInvocations.put(context, inv);
            //System.out.printf("pushing %s %s to %s %s in %s\n", inv.className, inv.methodName, parent.className, parent.methodName, context.toString());
            //System.out.printf("current for %s is %s %s\n", context.toString(), inv.className, inv.methodName);
        }
        else {
            inv = new Invocation();
            currentInvocations.put(context, inv);
            //System.out.printf("current for %s is %s %s\n", context.toString(), inv.className, inv.methodName);
            before(context, className, methodName);
        }
        inv.startTimeCurrent = System.currentTimeMillis();
    }
    
    public static void after(ThreadContext context, String className, String methodName) {
        if (!shouldProfile) return;
        Invocation current = currentInvocations.get(context);
        long time;
        if (current == null) return;
        if (context.getCurrentFrame() == null) {
            System.out.printf("Current frame appears to be null... ??\n");
        }
        else {
            boolean stop = false;
            while (current.frame != context.getCurrentFrame().hashCode() && !stop) {
                if (current.parent == null) {
                    //System.out.printf("Oops, reached the top of the invocation tree without matching the JRuby Frame.\n");
                    stop = true;
                }
                else {
                    time = System.currentTimeMillis() - current.startTimeCurrent;
                    current.duration += time;
                    current.startTimeCurrent = 0;
                    current = current.parent;
                }
            }
        }
        time = System.currentTimeMillis() - current.startTimeCurrent;
        if (current.startTimeCurrent == 0)
            System.out.printf("warning, startTimeCurrent is 0 in after\n");
        current.startTimeCurrent = 0;
        current.duration += time;
        current.returned = true;
        current.count += 1;
        if (current.parent != null) {
            currentInvocations.put(context, current.parent);
            //System.out.printf("popping: %s %s took %dms, now at %s %s\n", current.className, current.methodName, time, current.parent.className, current.parent.methodName);
        }
        //System.out.printf("current for %s is %s %s\n", context.toString(), current.parent.className, current.parent.methodName);
    }

}
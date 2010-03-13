
package org.jruby.prof;

import java.util.*;
import org.jruby.Ruby;
import org.jruby.runtime.ThreadContext;

public class JRubyProf {

    private static Map<ThreadContext, Invocation> currentInvocations;

    public static ProfEventHook hook = null;
    public static long startedTracingTime;
    public static long lastTracingDuration;
    
    public static void startTracing() {
        hook = new ProfEventHook();
        Ruby.getGlobalRuntime().addEventHook(hook);
        currentInvocations = Collections.synchronizedMap(new HashMap<ThreadContext, Invocation>());
        shouldProfile = true;
        startedTracingTime = System.currentTimeMillis();
    }
    
    public static Map<ThreadContext, Invocation> stopTracing() {
        shouldProfile = false;
        Ruby.getGlobalRuntime().removeEventHook(hook);
        hook = null;
        lastTracingDuration = System.currentTimeMillis() - startedTracingTime;
        for (ThreadContext context : currentInvocations.keySet()) {
            Invocation inv = currentInvocations.get(context);
            while (inv.parent != null)
                inv = inv.parent;
            currentInvocations.put(context, inv);
        }
        return currentInvocations;
    }
    
    public static boolean isRunning() {
        return shouldProfile;
    }

    private static boolean shouldProfile = false;
    private boolean initProfileMethod = false;

    public static synchronized void before(ThreadContext context, String className, String methodName) {
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
    
    public static synchronized void after(ThreadContext context, String className, String methodName) {
        if (!shouldProfile) return;
        Invocation current = currentInvocations.get(context);
        long time;
        if (current == null) return;
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
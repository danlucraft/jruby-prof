
package org.jruby.prof;

import java.util.*;
public class Invocation {
    public String className;
    public String methodName;
    public Invocation parent;
    public boolean returned = false;
    public long duration = 0;
    public long count = 0;
    public long startTimeCurrent;
    public ArrayList<Invocation> children = new ArrayList<Invocation>();
}
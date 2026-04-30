import { startOfDay, endOfDay, startOfWeek, endOfWeek, startOfMonth, endOfMonth, startOfYear, endOfYear } from 'date-fns';

export const dayRange = (d: Date) => ({ from: startOfDay(d), to: endOfDay(d) });
export const weekRange = (d: Date) => ({ from: startOfWeek(d, { weekStartsOn: 1 }), to: endOfWeek(d, { weekStartsOn: 1 }) });
export const monthRange = (d: Date) => ({ from: startOfMonth(d), to: endOfMonth(d) });
export const yearRange = (d: Date) => ({ from: startOfYear(d), to: endOfYear(d) });

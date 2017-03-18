using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using lssCore.Database;

namespace lssCore.Services
{
    public class ScheduleEventRepository
    {

        public IList<ScheduleEvent> GetAllScheduleEvents(long ?serviceId)
        {
            IList<ScheduleEvent> resultList = null;
            try
            {
                resultList = new List<ScheduleEvent>();
                using (var db = new EntitiesContext())
                {
                    var query = from b in db.ScheduleEvents
                                where (b.ServiceId == serviceId)
                                select b;

                    foreach (var item in query)
                    {
                        resultList.Add(item);
                    }


                }
            }
            catch (Exception ex)
            {

            }
            return (resultList);

        }
        public ScheduleEvent GetScheduleEventById(long paramId)
        {
            ScheduleEvent scheduleEvent = null;
            try {
                using (var db = new EntitiesContext())
                {
                    scheduleEvent = db.ScheduleEvents.Single(e => e.Id == paramId);
                }
            }
            catch (Exception ex)
            {
             
            }
            return scheduleEvent;
        }
        public bool DeleteScheduleEvent(long paramId)
        {
            bool retVal = false;
            try
            {
                using (var db = new EntitiesContext())
                {
                    var scheduleEventDelete = db.ScheduleEvents.Single(e => e.Id == paramId);

                    db.ScheduleEvents.Remove(scheduleEventDelete);
                    db.SaveChanges();
                    retVal = true;
                }
            }

            catch (Exception ex)
            {
                retVal = false;
            }
            return retVal;
        }
        public void AddScheduleEvent(ScheduleEvent scheduleEvent)
        {
            try
            {
                using (var db = new EntitiesContext())
                {
                    db.ScheduleEvents.Add(scheduleEvent);
                    db.SaveChanges();
                }
            }

            catch (Exception ex)
            {
            }
        }
        public void UpdateScheduleEvent(ScheduleEvent scheduleEventUpdate)
        {
            try
            {
                using (var db = new EntitiesContext())
                {
                    var scheduleEventOriginal = db.ScheduleEvents.Find(scheduleEventUpdate.Id);

                    var entry = db.Entry(scheduleEventOriginal);
                    entry.State = System.Data.Entity.EntityState.Modified;
                    entry.CurrentValues.SetValues(scheduleEventUpdate);
                    db.SaveChanges();

                }
            }
            catch (Exception ex)
            {
            }
        }
    }
}
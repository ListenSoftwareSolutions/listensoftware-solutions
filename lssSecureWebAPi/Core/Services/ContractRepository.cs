using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using lssCore.Database;

namespace lssCore.Services
{
    public class ContractRepository
    {
        public ContractRepository()
        { }
        public bool DeleteContract(int contractId)
        {
            bool retVal = false;
            try
            {
                using (var db = new DatabaseContext())
                {
                    var contract = db.Contracts.Single(e => e.ContractId==contractId);

                    db.Contracts.Remove(contract);
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
        public void AddContract(Contract contract)
        {
            try
            {
                using (var db = new DatabaseContext())
                {
                    db.Contracts.Add(contract);
                    db.SaveChanges();
                }
            }

            catch (Exception ex)
            {
            }
        }
        public void UpdateContract(Contract contract)
        {
            try
            {
                using (var db = new DatabaseContext())
                {
                    var contractOriginal = db.Contracts.Find(contract.ContractId);

                    var entry = db.Entry(contractOriginal);
                    entry.State = System.Data.Entity.EntityState.Modified;
                    entry.CurrentValues.SetValues(contract);
                    db.SaveChanges();

                }
            }
            catch (Exception ex)
            {
            }
        }
        public Contract GetContractsById(int id)
        {
            Contract retVal=null;
            try
            {
                using (var db = new DatabaseContext())
                {
                    var query = (from b in db.Contracts
                                where (b.ContractId==id)
                                select b).FirstOrDefault();

                    retVal = query;


                }
            }

            catch (Exception ex)
            { }
            return retVal;
        }
        public List<Contract> GetContractsByAddressId(int addressId)
        {
            List<Contract> resultList = new List<Contract>();
            try
            {
                using (var db = new DatabaseContext())
                {
                    var query = from b in db.Contracts
                                where(b.AddressId==addressId)
                                select b;

                    query = query.OrderBy(s => s.StartDate);


                    foreach (var item in query)
                    {
                        resultList.Add(item);
                    }


                }
            }

            catch (Exception ex)
            { }
            return resultList;
        }
        List<Contract> GetAllContracts()
        {
            List<Contract> resultList = new List<Contract>();
            try
            {
                using (var db = new DatabaseContext())
                {
                    var query = from b in db.Contracts select b;

                    query = query.OrderBy(s => s.StartDate);


                    foreach (var item in query)
                    {
                        resultList.Add(item);
                    }


                }
            }

            catch (Exception ex)
            { }
            return resultList;
        }
    }
}


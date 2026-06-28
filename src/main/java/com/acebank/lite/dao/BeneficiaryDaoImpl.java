package com.acebank.lite.dao;

import com.acebank.lite.models.Beneficiary;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.QueryLoader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class BeneficiaryDaoImpl implements BeneficiaryDao {
    private static final Logger logger = LoggerFactory.getLogger(BeneficiaryDaoImpl.class);

    @Override
    public boolean save(Beneficiary beneficiary) {
        String sql = QueryLoader.getQuery("beneficiary.insert");
        if (sql == null) {
            // fallback if not in queries.yaml
            sql = "INSERT INTO BENEFICIARIES (OWNER_ACCOUNT, BENEFICIARY_ACCOUNT, BENEFICIARY_NAME, BANK_NAME, IFSC_CODE, NICKNAME, IS_ACTIVE) VALUES (?, ?, ?, ?, ?, ?, ?)";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, beneficiary.ownerAccount());
            stmt.setInt(2, beneficiary.beneficiaryAccount());
            stmt.setString(3, beneficiary.beneficiaryName());
            stmt.setString(4, beneficiary.bankName());
            stmt.setString(5, beneficiary.ifscCode());
            stmt.setString(6, beneficiary.nickname());
            stmt.setBoolean(7, beneficiary.isActive());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Failed to save beneficiary for owner account {}", beneficiary.ownerAccount(), e);
            return false;
        }
    }

    @Override
    public Optional<Beneficiary> findById(long id) {
        String sql = QueryLoader.getQuery("beneficiary.findById");
        if (sql == null) {
            sql = "SELECT * FROM BENEFICIARIES WHERE ID = ?";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToBeneficiary(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Failed to find beneficiary by ID {}", id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Beneficiary> findByOwnerAccount(int ownerAccount) {
        List<Beneficiary> beneficiaries = new ArrayList<>();
        String sql = QueryLoader.getQuery("beneficiary.findByOwner");
        if (sql == null) {
            sql = "SELECT * FROM BENEFICIARIES WHERE OWNER_ACCOUNT = ? ORDER BY NICKNAME ASC";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerAccount);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    beneficiaries.add(mapResultSetToBeneficiary(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Failed to find beneficiaries for owner {}", ownerAccount, e);
        }
        return beneficiaries;
    }

    @Override
    public boolean update(Beneficiary beneficiary) {
        String sql = QueryLoader.getQuery("beneficiary.update");
        if (sql == null) {
            sql = "UPDATE BENEFICIARIES SET BENEFICIARY_ACCOUNT = ?, BENEFICIARY_NAME = ?, BANK_NAME = ?, IFSC_CODE = ?, NICKNAME = ?, IS_ACTIVE = ? WHERE ID = ? AND OWNER_ACCOUNT = ?";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, beneficiary.beneficiaryAccount());
            stmt.setString(2, beneficiary.beneficiaryName());
            stmt.setString(3, beneficiary.bankName());
            stmt.setString(4, beneficiary.ifscCode());
            stmt.setString(5, beneficiary.nickname());
            stmt.setBoolean(6, beneficiary.isActive());
            stmt.setLong(7, beneficiary.id());
            stmt.setInt(8, beneficiary.ownerAccount());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Failed to update beneficiary {}", beneficiary.id(), e);
            return false;
        }
    }

    @Override
    public boolean delete(long id, int ownerAccount) {
        String sql = QueryLoader.getQuery("beneficiary.delete");
        if (sql == null) {
            sql = "DELETE FROM BENEFICIARIES WHERE ID = ? AND OWNER_ACCOUNT = ?";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.setInt(2, ownerAccount);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Failed to delete beneficiary {}", id, e);
            return false;
        }
    }

    private Beneficiary mapResultSetToBeneficiary(ResultSet rs) throws SQLException {
        return new Beneficiary(
            rs.getInt("ID"),
            rs.getInt("OWNER_ACCOUNT"),
            rs.getInt("BENEFICIARY_ACCOUNT"),
            rs.getString("BENEFICIARY_NAME"),
            rs.getString("BANK_NAME"),
            rs.getString("IFSC_CODE"),
            rs.getString("NICKNAME"),
            rs.getBoolean("IS_ACTIVE"),
            rs.getTimestamp("CREATED_AT").toLocalDateTime()
        );
    }
}
